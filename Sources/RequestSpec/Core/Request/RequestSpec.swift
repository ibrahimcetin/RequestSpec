//
//  RequestSpec.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 7.10.2025.
//

import Foundation

/// A protocol for defining reusable, type-safe request specifications.
///
/// `RequestSpec` is the recommended way to define network requests in your application. It wraps a ``Request``
/// type in a named, reusable definition that can be parameterized with custom properties. This provides a clean
/// abstraction layer that makes your networking code more maintainable, organized, and testable.
///
/// Use `RequestSpec` to create reusable request definitions with parameters, build organized API clients with
/// custom initializers, or structure your networking layer for production applications.
///
/// ## Usage
///
/// ```swift
/// struct CreateCommentInput: Encodable {
///     let text: String
///     let postID: Int
///     let userID: Int
/// }
///
/// struct Comment: Decodable {
///     let id: Int
///     let text: String
/// }
///
/// struct CreateCommentRequest: RequestSpec {
///     let input: CreateCommentInput
///     let authToken: String?
///     let includeMetadata: Bool
///
///     // Notice: Post<Comment> means "POST request that returns a Comment"
///     var request: Post<Comment> {
///         Post("comments")
///             .headers {
///                 ContentType("application/json")
///                 Accept("application/json")
///
///                 if let token = authToken {
///                     Authorization("Bearer \(token)")
///                 }
///             }
///             .queryItems {
///                 if includeMetadata {
///                     Item("include", value: "metadata")
///                 }
///             }
///             .body {
///                 input
///             }
///             .timeout(15)
///     }
/// }
///
/// // Using with NetworkService
/// let input = CreateCommentInput(text: "Great post!", postID: 1, userID: 42)
/// let request = CreateCommentRequest(input: input, authToken: "abc123", includeMetadata: true)
/// let response = try await networkService.send(request)
/// print("Created comment: \(response.body.id)")
/// ```
///
/// - Note: While you can use ``Request`` types like ``Get`` or ``Post`` directly for quick prototyping
///   and experimentation, wrapping them in a `RequestSpec` is recommended for **production** code.
///
/// - SeeAlso:
///    ``Request``
public protocol RequestSpec: Sendable {
    /// The underlying request type that defines the HTTP request structure.
    ///
    /// - SeeAlso:
    ///     - ``Request``
    ///     - ``Get``
    ///     - ``Post``
    ///     - ``Put``
    ///     - ``Patch``
    ///     - ``Delete``
    associatedtype RequestType: Request

    /// The underlying request that defines the actual HTTP request structure.
    ///
    /// This property is typically computed, allowing you to construct the ``Request`` using
    /// the spec's stored properties as parameters for paths, headers, query items, or body data.
    var request: RequestType { get }
}

// MARK: - Helpers

extension RequestSpec {
    /// Build a URLRequest from this request spec and a base URL.
    ///
    /// - Parameter baseURL: The base URL to construct the full request URL
    /// - Returns: A configured URLRequest ready to be used with URLSession or other networking libraries
    /// - Throws: ``RequestSpecError/invalidURL`` if the URL cannot be constructed
    ///
    /// - Note: This is a shortcut for ``Request/urlRequest(baseURL:)`` method.
    public func urlRequest(baseURL: URL) throws(RequestSpecError) -> URLRequest {
        try self.request.urlRequest(baseURL: baseURL)
    }

    /// The expected response type of the underlying request.
    ///
    /// This typealias is a **shorthand** for `RequestType.ResponseBody`, letting you
    /// refer directly to the return type of the underlying request.
    public typealias ResponseBody = RequestType.ResponseBody
}
