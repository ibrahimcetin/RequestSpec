//
//  Put.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

/// A protocol for PUT requests
public protocol PutRequest: Request {}

/// A PUT request for updating resources
public struct Put<ResponseBody: Decodable>: PutRequest {
    /// The unique identifier for this request
    public let id: UUID = UUID()

    /// HTTP method (always PUT)
    public let method: HTTPMethod = .put

    /// Path components for building the URL
    public let pathComponents: [String]

    /// Request components (headers, query items, etc.)
    public var components: RequestComponents

    /// Create a PUT request with path components
    public init(_ pathComponents: String...) {
        self.pathComponents = pathComponents
        self.components = RequestComponents()
    }
}
