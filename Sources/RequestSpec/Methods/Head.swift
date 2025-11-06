//
//  Head.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

/// A protocol for HEAD requests
public protocol HeadRequest: Request {}

/// A HEAD request for checking resources
public struct Head<ResponseBody: Decodable>: HeadRequest {
    /// The unique identifier for this request
    public let id: UUID = UUID()

    /// HTTP method (always HEAD)
    public let method: HTTPMethod = .head

    /// Path components for building the URL
    public let pathComponents: [String]

    /// Request components (headers, query items, etc.)
    public var components: RequestComponents

    /// Create a HEAD request with path components
    public init(_ pathComponents: String...) {
        self.pathComponents = pathComponents
        self.components = RequestComponents()
    }
}
