//
//  Put.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

/// A protocol that marks a request as a PUT request.
///
/// This protocol extends ``Request`` and is used for type constraints and identification
/// of PUT requests in the library.
public protocol PutRequest: Request {}

/// A PUT request for replacing or updating entire resources on the server.
///
/// `Put` represents an HTTP PUT request typically used for complete resource replacement.
/// Unlike ``Patch``, which performs partial updates, PUT is intended to replace the entire
/// resource with the provided data.
///
/// - Note: Use ``Patch`` for partial updates and `Put` for complete resource replacement.
///   The generic `ResponseBody` parameter specifies the type to decode from the response.
///
/// - SeeAlso:
///   - ``Request``
///   - ``Post``
///   - ``Patch``
///   - ``NetworkService``
public struct Put<ResponseBody: Decodable>: PutRequest {
    /// The unique identifier for this request instance.
    public let id: UUID = UUID()

    /// The HTTP method for this request (always `.put`).
    public let method: HTTPMethod = .put

    /// The path components that form the URL path.
    ///
    /// These components are joined with "/" to construct the request path.
    public let pathComponents: [String]

    /// The configuration components for this request.
    ///
    /// Contains headers, query items, body, timeout, and other request settings.
    public var components: RequestComponents

    /// Creates a PUT request with the specified path components.
    ///
    /// - Parameter pathComponents: Variadic string parameters that form the URL path.
    ///   For example, `Put<User>("users", "42")` creates a request to `/users/42`.
    public init(_ pathComponents: String...) {
        self.pathComponents = pathComponents
        self.components = RequestComponents()
    }
}
