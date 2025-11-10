//
//  RequestSpec.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 7.10.2025.
//

import Foundation

/// Protocol that defines a request definition
public protocol RequestSpec: Sendable {
    /// The type of request body
    associatedtype Body: Request

    associatedtype ResponseBody where ResponseBody == Body.ResponseBody
    var body: Body { get }
}

extension RequestSpec {
    /// Build a URLRequest from this request and a base URL
    /// - Parameter baseURL: The base URL
    /// - Returns: A configured URLRequest
    /// - Throws:  Any error thrown while constructing the `URLRequest`.
    ///
    /// This is a shortcut for ``Request/urlRequest(baseURL:)`` method.
    public func urlRequest(baseURL: URL) throws -> URLRequest {
        try self.body.urlRequest(baseURL: baseURL)
    }
}
