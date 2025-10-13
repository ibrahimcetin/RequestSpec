//
//  RequestSpec.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 7.10.2025.
//

import Foundation

/// Base protocol for all network requests
public protocol Request: Identifiable {
    /// The response type this request expects
    associatedtype Response: Decodable

    /// The unique identifier for this request
    var id: UUID { get }

    /// The HTTP method for this request
    var method: HTTPMethod { get }

    /// Path components for the request URL
    var pathComponents: [String] { get }

    /// Request components (headers, query items, body, etc.)
    var components: RequestComponents { get set }

    /// Create a request with path components
    init(_ pathComponents: String...)
}

extension Request {
    public var id: UUID { UUID() }
}

extension Request {
    public func response(_ response: Response.Type) -> Self {
        self
    }
}

// MARK: - URLRequest Builder

extension Request {
    /// Build a URLRequest from this request and a base URL
    /// - Parameter baseURL: The base URL string
    /// - Returns: A configured URLRequest
    public func urlRequest(baseURL: URL) throws -> URLRequest {
        // Build URL
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw RequestError.invalidBaseURL
        }

        // Build path
        let path = "/" + pathComponents.joined(separator: "/")
        urlComponents.path = path

        // Add query items
        if !components.queryItems.isEmpty {
            urlComponents.queryItems = components.queryItems
        }

        guard let url = urlComponents.url else {
            throw RequestError.invalidURL
        }

        // Create URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = components.timeout
        urlRequest.cachePolicy = components.cachePolicy
        urlRequest.allowsCellularAccess = components.allowsCellularAccess
        urlRequest.httpBody = components.body

        // Add headers
        for (key, value) in components.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return urlRequest
    }
}
