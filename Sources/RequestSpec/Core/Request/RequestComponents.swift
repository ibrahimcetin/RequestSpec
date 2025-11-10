//
//  RequestSpec.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 7.10.2025.
//

/// A container for the configurable components of an HTTP request.
///
/// `RequestComponents` holds all the configuration data needed to construct a complete HTTP request,
/// including headers, query parameters, body data, timeout settings, and other request options.
/// This struct is used internally by ``Request`` and is typically modified through request modifier methods
/// rather than being created directly.
///
/// - SeeAlso: ``Request``
public struct RequestComponents: Sendable {
    /// The HTTP headers to include in the request.
    ///
    /// Headers are stored as key-value pairs and are added to the request when it's executed.
    public var headers: [String: String]

    /// The query parameters to append to the request URL.
    ///
    /// These items are encoded into the URL's query string when the request is built.
    public var queryItems: [URLQueryItem]

    /// The body data for the request.
    ///
    /// For requests with a body (like POST or PUT), this contains the encoded data to send.
    public var body: Data?

    /// The timeout interval for the request in seconds.
    ///
    /// If the request doesn't complete within this time, it will fail with a timeout error.
    public var timeout: TimeInterval

    /// The cache policy for the request.
    ///
    /// Determines how the request interacts with the URL cache system.
    public var cachePolicy: URLRequest.CachePolicy

    /// Whether the request can use cellular network access.
    ///
    /// Set to `false` to restrict the request to Wi-Fi only.
    public var allowsCellularAccess: Bool

    /// Creates a new request components instance with the specified configuration.
    ///
    /// All parameters have sensible defaults, so you typically don't need to specify them all.
    ///
    /// - Parameters:
    ///   - headers: HTTP headers as key-value pairs (default: empty dictionary)
    ///   - queryItems: URL query parameters (default: empty array)
    ///   - body: Request body data (default: `nil`)
    ///   - timeout: Timeout interval in seconds (default: 60)
    ///   - cachePolicy: Cache policy (default: `.useProtocolCachePolicy`)
    ///   - allowsCellularAccess: Whether cellular access is allowed (default: `true`)
    public init(
        headers: [String: String] = [:],
        queryItems: [URLQueryItem] = [],
        body: Data? = nil,
        timeout: TimeInterval = 60,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        allowsCellularAccess: Bool = true
    ) {
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
        self.timeout = timeout
        self.cachePolicy = cachePolicy
        self.allowsCellularAccess = allowsCellularAccess
    }
}
