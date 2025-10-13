//
//  RequestSpec.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 7.10.2025.
//

/// A protocol for GET requests
public protocol GetRequest: Request {}

/// A GET request for retrieving resources
public struct Get<Response: Decodable>: GetRequest {
    /// HTTP method (always GET)
    public let method: HTTPMethod = .get

    /// Path components for building the URL
    public let pathComponents: [String]

    /// Request components (headers, query items, etc.)
    public var components: RequestComponents

    /// Create a GET request with path components
    public init(_ pathComponents: String...) {
        self.pathComponents = pathComponents
        self.components = RequestComponents()
    }
}
