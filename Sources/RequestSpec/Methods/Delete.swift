//
//  Delete.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

/// A protocol for DELETE requests
public protocol DeleteRequest: Request {}

/// A DELETE request for deleting resources
public struct Delete<ResponseBody: Decodable>: DeleteRequest {
    /// The unique identifier for this request
    public let id: UUID = UUID()

    /// HTTP method (always DELETE)
    public let method: HTTPMethod = .delete

    /// Path components for building the URL
    public let pathComponents: [String]

    /// Request components (headers, query items, etc.)
    public var components: RequestComponents

    /// Create a DELETE request with path components
    public init(_ pathComponents: String...) {
        self.pathComponents = pathComponents
        self.components = RequestComponents()
    }
}
