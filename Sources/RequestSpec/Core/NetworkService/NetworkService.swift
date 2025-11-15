//
//  RequestSpec.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 7.10.2025.
//

@_documentation(visibility: internal) @_exported import Foundation

#if canImport(FoundationNetworking)
    @_documentation(visibility: internal) @_exported import FoundationNetworking
#endif

/// The protocol for network service implementations that send HTTP requests.
///
/// `NetworkService` is the main entry point for executing HTTP requests in your application.
/// It defines the interface for sending both ``Request`` and ``RequestSpec`` instances and
/// receiving typed ``HTTPResponse`` values.
///
/// ## Implementation Example
///
/// Create a custom network service by conforming to this protocol and providing a base URL:
///
/// ```swift
/// final class MyAPIService: NetworkService {
///     let baseURL: URL = URL(string: "https://api.example.com")!
///
///     // session and decoder have default implementations
///     // but you can override them if needed:
///     let session: URLSession = {
///         let configuration = URLSessionConfiguration.default
///         configuration.timeoutIntervalForRequest = 30
///         return URLSession(configuration: configuration)
///     }()
///
///     let decoder: Decoder = {
///         let decoder = JSONDecoder()
///         decoder.keyDecodingStrategy = .convertFromSnakeCase
///         return decoder
///     }()
/// }
/// ```
///
/// ## Usage Example
///
/// Once you have a service implementation, use it to send requests:
///
/// ```swift
/// // Initialize your service
/// let service = MyAPIService()
///
/// // Send a simple GET request
/// let getUserRequest = Get<User>("users", "42")
/// let userResponse = try await service.send(getUserRequest)
/// print("User: \(userResponse.body.name)")
///
/// // Send a RequestSpec
/// struct GetUserRequest: RequestSpec {
///     let userID: String
///
///     var request: Get<User> {
///         Get("users", userID)
///     }
/// }
///
/// let requestSpec = GetUserRequest(userID: "42")
/// let response = try await service.send(requestSpec)
/// print("User: \(response.body.name)")
/// ```
///
/// - Note: For a more maintainable and testable network service layer, it's recommended to create
///   a custom protocol that inherits from `NetworkService` and define dedicated functions for each
///   request instead of calling `send(_:)` directly throughout your codebase. This approach provides
///   better encapsulation, easier mocking for tests, and clearer API boundaries. See the
///   [RequestSpecExample](https://github.com/ibrahimcetin/RequestSpec/tree/main/Examples/RequestSpecExample) for a detailed implementation.
///
/// - SeeAlso:
///   - ``Request``
///   - ``RequestSpec``
///   - ``HTTPResponse``
public protocol NetworkService {
    /// The base URL for all requests sent through this service.
    ///
    /// All request paths are appended to this base URL when constructing the full request URL.
    var baseURL: URL { get }

    /// The `URLSession` used to execute network requests.
    ///
    /// A default implementation is provided that uses `URLSession.shared`. Override this
    /// to customize session configuration, add delegates, or modify networking behavior.
    var session: URLSession { get }

    /// The decoder used to decode response bodies.
    ///
    /// A default implementation is provided that uses `JSONDecoder()`. Override this
    /// to customize decoding behavior, such as setting key decoding strategies or date formats.
    var decoder: Decoder { get }

    /// Sends a request and returns the decoded response.
    ///
    /// This method builds a `URLRequest` from the provided ``Request``, executes it using the
    /// session, and decodes the response body into the expected type.
    ///
    /// - Parameter request: The request to send
    /// - Returns: An ``HTTPResponse`` containing the decoded body and HTTP metadata
    ///
    /// - Note: Use `Data` as the response type if you don't want automatic decoding
    ///   e.g., `Get<Data>("endpoint")`.
    func send<R: Request>(_ request: R) async throws -> HTTPResponse<R.ResponseBody>

    /// Sends a request spec and returns the decoded response.
    ///
    /// This method extracts the underlying ``Request`` from the ``RequestSpec`` and sends it.
    ///
    /// - Parameter requestSpec: The request spec to send
    /// - Returns: An ``HTTPResponse`` containing the decoded body and HTTP metadata
    ///
    /// - Note: Use `Data` as the response type if you don't want automatic decoding
    ///   e.g., `Get<Data>("endpoint")`.
    func send<RS: RequestSpec>(_ requestSpec: RS) async throws -> HTTPResponse<RS.ResponseBody>
}

extension NetworkService {
    /// Default implementation that returns `URLSession.shared`.
    ///
    /// Override this property in your conforming type to provide a custom session configuration.
    public var session: URLSession {
        URLSession.shared
    }

    /// Default implementation that returns a standard `JSONDecoder`.
    ///
    /// Override this property in your conforming type to customize decoding behavior.
    public var decoder: Decoder {
        JSONDecoder()
    }
}

extension NetworkService {
    /// Fetches raw data for a request.
    ///
    /// This internal helper method constructs a `URLRequest` and executes it using the session.
    ///
    /// - Parameter request: The request to fetch data for
    /// - Returns: A tuple containing the response data and the `URLResponse`
    /// - Throws: Errors from URL construction or network execution
    func data<R: Request>(for request: R) async throws -> (Data, URLResponse) {
        let urlRequest = try request.urlRequest(baseURL: baseURL)
        return try await session.data(for: urlRequest)
    }

    /// Decodes data into the specified type.
    ///
    /// This internal helper method handles special cases for `String` and `Data` types,
    /// and uses the decoder for other `Decodable` types.
    ///
    /// - Parameters:
    ///   - type: The type to decode into
    ///   - data: The data to decode
    /// - Returns: The decoded value
    /// - Throws: Decoding errors if the data cannot be decoded into the specified type
    nonisolated func decode<T: Decodable>(_ type: T.Type, from data: Data) async throws -> T {
        switch type {
        case is String.Type:
            return String(decoding: data, as: UTF8.self) as! T
        case is Data.Type:
            return data as! T
        default:
            return try decoder.decode(type, from: data)
        }
    }

    /// Default implementation of `send(_:)` for ``Request`` types.
    ///
    /// This method fetches the data, decodes it into the expected type, and wraps it
    /// in an ``HTTPResponse`` with the original HTTP response metadata.
    public func send<R: Request>(_ request: R) async throws -> HTTPResponse<R.ResponseBody> {
        let (data, response) = try await data(for: request)
        let httpURLResponse = response as! HTTPURLResponse

        do {
            let body = try await decode(R.ResponseBody.self, from: data)
            return HTTPResponse(body: body, originalResponse: httpURLResponse)
        } catch {
            throw RequestSpecError.decodingFailed(
                response: HTTPResponse(body: data, originalResponse: httpURLResponse),
                underlyingError: error
            )
        }
    }

    /// Default implementation of `send(_:)` for ``RequestSpec`` types.
    ///
    /// This method extracts the underlying ``Request`` from the spec and sends it.
    public func send<RS: RequestSpec>(_ requestSpec: RS) async throws -> HTTPResponse<RS.ResponseBody> {
        try await send(requestSpec.request)
    }
}
