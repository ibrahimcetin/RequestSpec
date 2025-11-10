//
//  Options.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

/// A protocol that marks a request as an OPTIONS request.
///
/// This protocol extends ``Request`` and is used for type constraints and identification
/// of OPTIONS requests in the library.
public protocol OptionsRequest: Request {}

/// An OPTIONS request for discovering communication options for a resource.
///
/// `Options` represents an HTTP OPTIONS request used to describe the communication options
/// available for a target resource. This is commonly used for CORS (Cross-Origin Resource Sharing)
/// preflight requests to determine what HTTP methods and headers are allowed.
///
/// - Note: OPTIONS requests typically return information in the response headers (like `Allow`,
///   `Access-Control-Allow-Methods`, etc.). Use `Data` or `String` as the `ResponseBody` type.
///
/// - SeeAlso:
///   - ``Request``
///   - ``HTTPResponse``
///   - ``NetworkService``
public struct Options<ResponseBody: Decodable>: OptionsRequest {
    /// The unique identifier for this request instance.
    public let id: UUID = UUID()

    /// The HTTP method for this request (always `.options`).
    public let method: HTTPMethod = .options

    /// The path components that form the URL path.
    ///
    /// These components are joined with "/" to construct the request path.
    public let pathComponents: [String]

    /// The configuration components for this request.
    ///
    /// Contains headers, query items, body, timeout, and other request settings.
    public var components: RequestComponents

    /// Creates an OPTIONS request with the specified path components.
    ///
    /// - Parameter pathComponents: Variadic string parameters that form the URL path.
    ///   For example, `Options<Data>("users")` creates a request to `/users`.
    public init(_ pathComponents: String...) {
        self.pathComponents = pathComponents
        self.components = RequestComponents()
    }
}
