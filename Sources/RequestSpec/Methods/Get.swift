//
//  RequestSpec.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 7.10.2025.
//

/// A protocol that marks a request as a GET request.
///
/// This protocol extends ``Request`` and is used for type constraints and identification
/// of GET requests in the library.
public protocol GetRequest: Request {}

/// A GET request for retrieving resources from the server.
///
/// `Get` is the most commonly used request type for fetching data from APIs. It represents
/// an HTTP GET request with a specified response type and supports all standard request
/// modifiers for headers, query parameters, timeout, and other configurations.
///
/// ## Usage
///
/// ```swift
/// let request = Get<User>("users", "42")
///     .headers {
///         Authorization("Bearer token")
///     }
///     .queryItems {
///         Item("page", value: "1")
///     }
///
/// let response = try await service.send(request)
/// ```
///
/// - Note: The generic `ResponseBody` parameter specifies the type to decode from the response.
///   It must conform to `Decodable`.
///
/// - SeeAlso:
///   - ``Request``
///   - ``Post``
///   - ``Put``
///   - ``NetworkService``
public struct Get<ResponseBody: Decodable>: GetRequest {
    /// The unique identifier for this request instance.
    public let id: UUID = UUID()

    /// The HTTP method for this request (always `.get`).
    public let method: HTTPMethod = .get

    /// The path components that form the URL path.
    ///
    /// These components are joined with "/" to construct the request path.
    public let pathComponents: [String]

    /// The configuration components for this request.
    ///
    /// Contains headers, query items, body, timeout, and other request settings.
    public var components: RequestComponents

    /// Creates a GET request with the specified path components.
    ///
    /// - Parameter pathComponents: Variadic string parameters that form the URL path.
    ///   For example, `Get<User>("users", "42")` creates a request to `/users/42`.
    public init(_ pathComponents: String...) {
        self.pathComponents = pathComponents
        self.components = RequestComponents()
    }
}
