//
//  RequestSpec.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 7.10.2025.
//

/// A protocol that marks a request as a POST request.
///
/// This protocol extends ``Request`` and is used for type constraints and identification
/// of POST requests in the library.
public protocol PostRequest: Request {}

/// A POST request for creating new resources on the server.
///
/// `Post` represents an HTTP POST request typically used for submitting data to create new
/// resources. It supports all standard request modifiers, with the body modifier being
/// particularly important for POST requests to send data to the server.
///
/// ## Usage
///
/// ```swift
/// let request = Post<User>("users")
///     .headers {
///         Authorization("Bearer token")
///     }
///     .body {
///         CreateUserInput(name: "John", email: "john@example.com")
///     }
///     .timeout(10)
///
/// let response = try await service.send(request)
/// ```
///
/// - Important: The generic `ResponseBody` parameter specifies the type to decode from the response.
///   It must conform to `Decodable`. Use `body()` modifier to attach request payload.
///
/// - SeeAlso:
///   - ``Request``
///   - ``Get``
///   - ``Put``
///   - ``Patch``
///   - ``NetworkService``
public struct Post<ResponseBody: Decodable>: PostRequest {
    /// The unique identifier for this request instance.
    public let id: UUID = UUID()

    /// The HTTP method for this request (always `.post`).
    public let method: HTTPMethod = .post

    /// The path components that form the URL path.
    ///
    /// These components are joined with "/" to construct the request path.
    public let pathComponents: [String]

    /// The configuration components for this request.
    ///
    /// Contains headers, query items, body, timeout, and other request settings.
    public var components: RequestComponents

    /// Creates a POST request with the specified path components.
    ///
    /// - Parameter pathComponents: Variadic string parameters that form the URL path.
    ///   For example, `Post<User>("users")` creates a request to `/users`.
    public init(_ pathComponents: String...) {
        self.pathComponents = pathComponents
        self.components = RequestComponents()
    }
}
