//
//  Delete.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

/// A protocol that marks a request as a DELETE request.
///
/// This protocol extends ``Request`` and is used for type constraints and identification
/// of DELETE requests in the library.
public protocol DeleteRequest: Request {}

/// A DELETE request for removing resources from the server.
///
/// `Delete` represents an HTTP DELETE request used to remove a resource from the server.
/// DELETE requests typically target a specific resource identified by the URL path and
/// return either an empty response or a confirmation message.
///
/// - Note: The generic `ResponseBody` parameter specifies the type to decode from the response.
///   For DELETE operations that return no content, you can use `Data` or `String` as the response type.
///
/// - SeeAlso:
///   - ``Request``
///   - ``Get``
///   - ``Post``
///   - ``NetworkService``
public struct Delete<ResponseBody: Decodable>: DeleteRequest {
    /// The unique identifier for this request instance.
    public let id: UUID = UUID()

    /// The HTTP method for this request (always `.delete`).
    public let method: HTTPMethod = .delete

    /// The path components that form the URL path.
    ///
    /// These components are joined with "/" to construct the request path.
    public let pathComponents: [String]

    /// The configuration components for this request.
    ///
    /// Contains headers, query items, body, timeout, and other request settings.
    public var components: RequestComponents

    /// Creates a DELETE request with the specified path components.
    ///
    /// - Parameter pathComponents: Variadic string parameters that form the URL path.
    ///   For example, `Delete<Data>("users", "42")` creates a request to `/users/42`.
    public init(_ pathComponents: String...) {
        self.pathComponents = pathComponents
        self.components = RequestComponents()
    }
}
