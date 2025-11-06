//
//  Patch.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

/// A protocol for PATCH requests
public protocol PatchRequest: Request {}

/// A PATCH request for updating resources
public struct Patch<ResponseBody: Decodable>: PatchRequest {
    /// The unique identifier for this request
    public let id: UUID = UUID()

    /// HTTP method (always PATCH)
    public let method: HTTPMethod = .patch

    /// Path components for building the URL
    public let pathComponents: [String]

    /// Request components (headers, query items, etc.)
    public var components: RequestComponents

    /// Create a PATCH request with path components
    public init(_ pathComponents: String...) {
        self.pathComponents = pathComponents
        self.components = RequestComponents()
    }
}
