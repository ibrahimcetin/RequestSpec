//
//  Head.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

/// A protocol that marks a request as a HEAD request.
///
/// This protocol extends ``Request`` and is used for type constraints and identification
/// of HEAD requests in the library.
public protocol HeadRequest: Request {}

/// A HEAD request for retrieving resource metadata without the body.
///
/// `Head` represents an HTTP HEAD request, which is identical to a ``Get`` request except that
/// the server only returns headers without the response body. This is useful for checking if a
/// resource exists, retrieving metadata, or checking cache validity without downloading the
/// entire resource.
///
/// - Note: Since HEAD requests don't return a body, use `Data` or `String` as the `ResponseBody` type.
///   The useful information will be in the response headers and status code.
///
/// - SeeAlso:
///   - ``Request``
///   - ``Get``
///   - ``HTTPResponse``
///   - ``NetworkService``
public struct Head<ResponseBody: Decodable>: HeadRequest {
    /// The unique identifier for this request instance.
    public let id: UUID = UUID()

    /// The HTTP method for this request (always `.head`).
    public let method: HTTPMethod = .head

    /// The path components that form the URL path.
    ///
    /// These components are joined with "/" to construct the request path.
    public let pathComponents: [String]

    /// The configuration components for this request.
    ///
    /// Contains headers, query items, body, timeout, and other request settings.
    public var components: RequestComponents

    /// Creates a HEAD request with the specified path components.
    ///
    /// - Parameter pathComponents: Variadic string parameters that form the URL path.
    ///   For example, `Head<Data>("users", "42")` creates a request to `/users/42`.
    public init(_ pathComponents: String...) {
        self.pathComponents = pathComponents
        self.components = RequestComponents()
    }
}
