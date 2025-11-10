//
//  Response.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 11.10.2025.
//

import Foundation

/// A generic HTTP response container that wraps the decoded response body with HTTP metadata.
///
/// `HTTPResponse` provides a type-safe way to access both the decoded response body and the underlying
/// HTTP response information like status codes and headers. It is returned by ``NetworkService`` when
/// sending requests.
///
/// ## Usage
///
/// ```swift
/// struct User: Decodable {
///     let id: Int
///     let name: String
/// }
///
/// let request = Get<User>("users", "42")
/// let response = try await networkService.send(request)
///
/// // Access the decoded body
/// print("User name: \(response.body.name)")
///
/// // Check the status
/// if response.status == .success {
///     print("Request successful!")
/// }
///
/// // Access headers
/// if let contentType = response.headers["Content-Type"] {
///     print("Content-Type: \(contentType)")
/// }
///
/// // Access status code directly
/// print("Status code: \(response.statusCode)")
/// ```
///
/// - SeeAlso: ``NetworkService``
public struct HTTPResponse<Body> {
    /// The decoded response body.
    ///
    /// The type of this property is determined by the generic `Body` parameter, which is typically
    /// inferred from the ``Request/ResponseBody`` associatedtype of the request.
    public let body: Body

    /// The original `HTTPURLResponse` from the network request.
    ///
    /// Use this property to access additional HTTP response information not exposed by other properties.
    public let originalResponse: HTTPURLResponse

    /// Creates an HTTP response with the decoded body and original HTTP response.
    ///
    /// - Parameters:
    ///   - body: The decoded response body
    ///   - originalResponse: The original `HTTPURLResponse` from the network request
    public init(body: Body, originalResponse: HTTPURLResponse) {
        self.body = body
        self.originalResponse = originalResponse
    }

    /// The HTTP status code of the response (e.g., 200, 404, 500).
    public var statusCode: Int {
        originalResponse.statusCode
    }

    /// The HTTP headers of the response as a string-to-string dictionary.
    ///
    /// Header keys and values are extracted from the original response's `allHeaderFields` dictionary,
    /// filtering to include only string key-value pairs.
    public var headers: [String: String] {
        originalResponse.allHeaderFields.reduce(into: [:]) { result, pair in
            if let key = pair.key as? String, let value = pair.value as? String {
                result[key] = value
            }
        }
    }
}

// MARK: - Sendable

extension HTTPResponse: Sendable where Body: Sendable {}

// MARK: - HTTP Response Status

/// Categories for HTTP response status codes.
///
/// `HTTPResponseStatus` classifies HTTP status codes into standard categories based on their numeric range,
/// making it easier to handle responses without checking specific status codes.
public enum HTTPResponseStatus: Sendable {
    /// Informational responses (100-199).
    case information

    /// Successful responses (200-299).
    case success

    /// Redirection messages (300-399).
    case redirection

    /// Client error responses (400-499).
    case clientError

    /// Server error responses (500-599).
    case serverError

    /// Status codes outside the standard ranges.
    case unknown
}

extension HTTPResponse {
    /// The category of the HTTP response status code.
    ///
    /// This property provides a convenient way to check the general category of the response
    /// without matching against specific status codes.
    ///
    /// ```swift
    /// let response = try await networkService.send(request)
    /// if response.status == .success {
    ///     print("Request successful!")
    /// }
    /// ```
    ///
    /// - Returns: A ``HTTPResponseStatus`` value categorizing the response:
    ///   - `.information`: 100-199
    ///   - `.success`: 200-299
    ///   - `.redirection`: 300-399
    ///   - `.clientError`: 400-499
    ///   - `.serverError`: 500-599
    ///   - `.unknown`: Any other status code
    public var status: HTTPResponseStatus {
        switch statusCode {
        case 100...199:
            return .information
        case 200...299:
            return .success
        case 300...399:
            return .redirection
        case 400...499:
            return .clientError
        case 500...599:
            return .serverError
        default:
            return .unknown
        }
    }
}
