//
//  RequestSpec.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 7.10.2025.
//

/// A protocol for POST requests
public protocol PostRequest: Request {}

/// A POST request for creating resources
public struct Post<ResponseBody: Decodable>: PostRequest {
    /// The unique identifier for this request
    public let id: UUID = UUID()

    /// HTTP method (always POST)
    public let method: HTTPMethod = .post

    /// Path components for building the URL
    public let pathComponents: [String]

    /// Request components (headers, query items, etc.)
    public var components: RequestComponents

    /// Create a POST request with path components
    public init(_ pathComponents: String...) {
        self.pathComponents = pathComponents
        self.components = RequestComponents()
    }
}
