//
//  Request+Modifiers.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

extension Request {
    /// Add headers using a result builder
    public func headers(@HeadersBuilder _ builder: () -> [any HeaderProtocol]) -> Self {
        var copy = self

        let headers = builder()
        for header in headers {
            copy.components.headers[header.key] = header.value
        }

        return copy
    }

    /// Add query items using a result builder
    public func queryItems(@QueryItemsBuilder _ builder: () -> [any QueryItemProtocol]) -> Self {
        var copy = self

        let queryItems = builder()
        copy.components.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }

        return copy
    }

    /// Add body using a result builder (converts to JSON)
    public func body(
        encoder: Encoder = JSONEncoder(), @BodyBuilder _ builder: () -> (any Encodable)?
    )
        -> Self
    {
        var copy = self
        let bodyDict = builder()

        if let bodyDict, let jsonData = try? encoder.encode(bodyDict) {
            copy.components.body = jsonData
            copy.components.headers["Content-Type"] = "application/json"
        }
        return copy
    }

    /// Set the request timeout
    public func timeout(_ interval: TimeInterval) -> Self {
        var copy = self
        copy.components.timeout = interval
        return copy
    }

    /// Set the cache policy
    public func cachePolicy(_ policy: URLRequest.CachePolicy) -> Self {
        var copy = self
        copy.components.cachePolicy = policy
        return copy
    }

    /// Set the cellular access
    /// - Parameter allowsCellularAccess: Whether the request can use cellular network
    public func allowsCellularAccess(_ allowsCellularAccess: Bool) -> Self {
        var copy = self
        copy.components.allowsCellularAccess = allowsCellularAccess
        return copy
    }
}
