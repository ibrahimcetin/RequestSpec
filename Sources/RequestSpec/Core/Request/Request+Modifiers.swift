//
//  Request+Modifiers.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

extension Request {
    /// Adds HTTP headers to the request using a result builder.
    ///
    /// This modifier allows you to specify multiple headers in a declarative way using the
    /// ``HeadersBuilder`` result builder. Headers are merged with any existing headers,
    /// with new values overriding existing ones for the same key.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Get<User>("users")
    ///     .headers {
    ///         Authorization("Bearer token")
    ///         Accept("application/json")
    ///     }
    /// ```
    ///
    /// ## Advanced Usage
    ///
    /// ```swift
    /// Post<User>("users")
    ///     .headers {
    ///         ContentType("application/json")
    ///
    ///         // Conditional headers
    ///         if let token = authToken {
    ///             Authorization("Bearer \(token)")
    ///         } else {
    ///             XApiKey("public-key")
    ///         }
    ///
    ///         // Loop through custom headers
    ///         for (key, value) in customHeaders {
    ///             Header(key, value: value)
    ///         }
    ///
    ///         // Void functions for side effects (logging, etc.)
    ///         logger.info("Headers configured")
    ///     }
    /// ```
    ///
    /// - Parameter builder: A closure that returns an array of headers using result builder syntax
    ///
    /// - Note: This method returns a copy of the request, allowing for method chaining.
    ///
    /// - SeeAlso: ``HeadersBuilder``
    public func headers(@HeadersBuilder _ builder: () -> [any HeaderProtocol]) -> Self {
        var copy = self

        let headers = builder()
        for header in headers {
            copy.components.headers[header.key] = header.value
        }

        return copy
    }

    /// Adds query parameters to the request URL using a result builder.
    ///
    /// This modifier allows you to specify URL query parameters in a declarative way using the
    /// ``QueryItemsBuilder`` result builder. The query items are appended to the request URL
    /// when the request is executed.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Get<[User]>("users")
    ///     .queryItems {
    ///         Item("page", value: "1")
    ///         Item("limit", value: "20")
    ///     }
    /// ```
    ///
    /// ## Advanced Usage
    ///
    /// ```swift
    /// Get<[User]>("users")
    ///     .queryItems {
    ///         Item("page", value: "\(page)")
    ///
    ///         // Conditional query items
    ///         if includeInactive {
    ///             Item("status", value: "all")
    ///         } else {
    ///             Item("status", value: "active")
    ///         }
    ///
    ///         // Loop through filters
    ///         for filter in filters {
    ///             Item("filter", value: filter)
    ///         }
    ///
    ///         // Void functions for side effects (logging, etc.)
    ///         logger.info("Query items configured")
    ///     }
    /// ```
    ///
    /// - Parameter builder: A closure that returns an array of query items using result builder syntax
    ///
    /// - Note: This method returns a copy of the request, allowing for method chaining.
    ///
    /// - SeeAlso: ``QueryItemsBuilder``
    public func queryItems(@QueryItemsBuilder _ builder: () -> [any QueryItemProtocol]) -> Self {
        var copy = self

        let queryItems = builder()
        copy.components.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }

        return copy
    }

    /// Adds a request body by encoding it using the specified encoder.
    ///
    /// This modifier allows you to specify the request body in a declarative way using the
    /// ``BodyBuilder`` result builder. The body is automatically encoded to JSON (or other format
    /// based on the encoder) and the appropriate Content-Type header is set.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Post<User>("users")
    ///     .body {
    ///         CreateUserInput(name: "John", email: "john@example.com")
    ///     }
    /// ```
    ///
    /// ## Advanced Usage
    ///
    /// ```swift
    /// Post<User>("users")
    ///     .body(encoder: JSONEncoder()) {
    ///         // Conditional body based on flag
    ///         if useDetailedInput {
    ///             DetailedUserInput(name: "John", email: "john@example.com", age: 30)
    ///         } else {
    ///             SimpleUserInput(name: "John", email: "john@example.com")
    ///         }
    ///
    ///         // Void functions for side effects (logging, etc.)
    ///         let _ = logger.info("Body configured")
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - encoder: The encoder to use for encoding the body (default: `JSONEncoder()`)
    ///   - builder: A closure that returns an encodable value using result builder syntax
    ///
    /// - Important: Only **one** encodable value is allowed per request. Attempting to provide
    ///   multiple body values will result in a compile-time error.
    ///
    /// - Note: This method returns a copy of the request, allowing for method chaining.
    ///   If the body is already `Data`, it will be used directly without encoding.
    ///
    /// - SeeAlso: ``BodyBuilder``
    public func body(encoder: Encoder = JSONEncoder(), @BodyBuilder _ builder: () -> (any Encodable)?) -> Self {
        var copy = self
        let bodyDict = builder()

        if let bodyDict {
            // Special case: if the body is already Data, use it directly
            if let bodyData = bodyDict as? Data {
                copy.components.body = bodyData
            } else if let jsonData = try? encoder.encode(bodyDict) {
                copy.components.body = jsonData
            }

            copy.components.headers["Content-Type"] = "application/json"  // #TODO: Make this dynamic based on the encoder
        }

        return copy
    }

    /// Sets the timeout interval for the request.
    ///
    /// The timeout interval specifies how long the request should wait before timing out.
    /// If no response is received within this interval, the request will fail with a timeout error.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Get<User>("users", "42")
    ///     .timeout(30)
    /// ```
    ///
    /// - Parameter interval: The timeout interval in seconds (default: 60 seconds)
    ///
    /// - Note: This method returns a copy of the request, allowing for method chaining.
    public func timeout(_ interval: TimeInterval) -> Self {
        var copy = self
        copy.components.timeout = interval
        return copy
    }

    /// Sets the cache policy for the request.
    ///
    /// The cache policy determines how the request interacts with the URL cache, controlling
    /// whether cached responses should be used or when the cache should be updated.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Get<User>("users", "42")
    ///     .cachePolicy(.reloadIgnoringLocalCacheData)
    /// ```
    ///
    /// - Parameter policy: The cache policy to use (default: `.useProtocolCachePolicy`)
    ///
    /// - Note: This method returns a copy of the request, allowing for method chaining.
    public func cachePolicy(_ policy: URLRequest.CachePolicy) -> Self {
        var copy = self
        copy.components.cachePolicy = policy
        return copy
    }

    /// Sets whether the request can use cellular network access.
    ///
    /// Use this modifier to control whether the request should be allowed to execute over
    /// a cellular connection or restricted to Wi-Fi only.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Get<LargeFile>("downloads", "file.zip")
    ///     .allowsCellularAccess(false) // Wi-Fi only
    /// ```
    ///
    /// - Parameter allowsCellularAccess: Whether the request can use cellular network (default: `true`)
    ///
    /// - Note: This method returns a copy of the request, allowing for method chaining.
    public func allowsCellularAccess(_ allowsCellularAccess: Bool) -> Self {
        var copy = self
        copy.components.allowsCellularAccess = allowsCellularAccess
        return copy
    }
}
