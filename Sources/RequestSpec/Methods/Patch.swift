//
//  Patch.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

/// A protocol that marks a request as a PATCH request.
///
/// This protocol extends ``Request`` and is used for type constraints and identification
/// of PATCH requests in the library.
public protocol PatchRequest: Request {}

/// A PATCH request for partially updating resources on the server.
///
/// `Patch` represents an HTTP PATCH request used for applying partial modifications to a resource.
/// Unlike ``Put``, which replaces the entire resource, PATCH only updates the fields included
/// in the request body, leaving other fields unchanged.
///
/// - Note: Use `Patch` for partial updates and ``Put`` for complete resource replacement.
///   The generic `ResponseBody` parameter specifies the type to decode from the response.
///
/// - SeeAlso:
///   - ``Request``
///   - ``Put``
///   - ``Post``
///   - ``NetworkService``
public struct Patch<ResponseBody: Decodable>: PatchRequest {
    /// The unique identifier for this request instance.
    public let id: UUID = UUID()

    /// The HTTP method for this request (always `.patch`).
    public let method: HTTPMethod = .patch

    /// The path components that form the URL path.
    ///
    /// These components are joined with "/" to construct the request path.
    public let pathComponents: [String]

    /// The configuration components for this request.
    ///
    /// Contains headers, query items, body, timeout, and other request settings.
    public var components: RequestComponents

    /// Creates a PATCH request with the specified path components.
    ///
    /// - Parameter pathComponents: Variadic string parameters that form the URL path.
    ///   For example, `Patch<User>("users", "42")` creates a request to `/users/42`.
    public init(_ pathComponents: String...) {
        self.pathComponents = pathComponents
        self.components = RequestComponents()
    }
}
