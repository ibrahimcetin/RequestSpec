//
//  RequestSpec.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 7.10.2025.
//

import Foundation

/// Base protocol for all network requests
public protocol Request: Identifiable, Sendable {
    /// The response type this request expects
    associatedtype ResponseBody: Decodable

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

// MARK: - URLRequest Builder

extension Request {
    /// Build a URLRequest from this request and a base URL
    /// - Parameter baseURL: The base URL
    /// - Returns: A configured URLRequest
    /// - Throws:  Any error thrown while constructing the `URLRequest`.
    public func urlRequest(baseURL: URL) throws -> URLRequest {
        // Build URL
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw RequestSpecError.invalidURL
        }

        // Build path
        let path = "/" + pathComponents.joined(separator: "/")
        urlComponents.path = path

        // Add query items
        if !components.queryItems.isEmpty {
            urlComponents.queryItems = components.queryItems
        }

        guard let url = urlComponents.url else {
            throw RequestSpecError.invalidURL
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

extension Request {
    public func cURLDescription(baseURL: URL) throws -> String {
        let request = try urlRequest(baseURL: baseURL)

        guard let url = request.url, let method = request.httpMethod
        else { throw RequestSpecError.invalidURL }

        var components = ["$ curl -v"]

        components.append("-X \(method)")

        let headers = request.allHTTPHeaderFields ?? [:]

        for header in headers.sorted(by: { $0.key < $1.key }) {
            let escapedValue = header.value.replacingOccurrences(of: "\"", with: "\\\"")
            components.append("-H \"\(header.key): \(escapedValue)\"")
        }

        if let httpBodyData = request.httpBody {
            let httpBody = String(decoding: httpBodyData, as: UTF8.self)
            var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
            escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")

            components.append("-d \"\(escapedBody)\"")
        }

        components.append("\"\(url.absoluteString)\"")

        return components.joined(separator: " \\\n")
    }
}
