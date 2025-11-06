//
//  Options.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

/// A protocol for OPTIONS requests
public protocol OptionsRequest: Request {}

/// A OPTIONS request for checking resources
public struct Options<ResponseBody: Decodable>: OptionsRequest {
    /// The unique identifier for this request
    public let id: UUID = UUID()

    /// HTTP method (always OPTIONS)
    public let method: HTTPMethod = .options

    /// Path components for building the URL
    public let pathComponents: [String]

    /// Request components (headers, query items, etc.)
    public var components: RequestComponents

    /// Create a OPTIONS request with path components
    public init(_ pathComponents: String...) {
        self.pathComponents = pathComponents
        self.components = RequestComponents()
    }
}
