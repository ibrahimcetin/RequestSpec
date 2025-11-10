//
//  Headers.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

/// A protocol for types that represent HTTP headers.
///
/// Conform to this protocol to create custom header types that can be used with the
/// ``Request/headers(_:)`` modifier. The library provides common header types like
/// ``Authorization``, ``ContentType``, and ``Accept``, as well as a generic ``Header``
/// type for custom headers.
///
/// - SeeAlso: ``Request/headers(_:)``
public protocol HeaderProtocol {
    /// The header field name (e.g., "Authorization", "Content-Type").
    var key: String { get }

    /// The header field value.
    var value: String { get }
}

/// A generic HTTP header with a custom key-value pair.
///
/// Use this type when you need to specify a header that doesn't have a dedicated type.
/// For common headers, prefer using the specialized types like ``Authorization``,
/// ``ContentType``, ``Accept``, etc.
public struct Header: HeaderProtocol {
    public let key: String
    public let value: String

    /// Creates a custom HTTP header with the specified key and value.
    ///
    /// - Parameters:
    ///   - key: The header field name
    ///   - value: The header field value
    public init(_ key: String, value: String) {
        self.key = key
        self.value = value
    }
}

// MARK: - Common Headers

/// The Authorization HTTP header for authentication credentials.
///
/// Use this header to provide authentication credentials like bearer tokens or basic auth.
///
/// ## Example
///
/// ```swift
/// .headers {
///     Authorization("Bearer abc123token")
/// }
/// ```
public struct Authorization: HeaderProtocol {
    public let key = "Authorization"
    public let value: String

    /// Creates an Authorization header with the specified value.
    ///
    /// - Parameter value: The authorization value (e.g., "Bearer token", "Basic base64credentials")
    public init(_ value: String) {
        self.value = value
    }
}

/// The Content-Type HTTP header specifying the media type of the request body.
///
/// Use this header to indicate the format of the data being sent in the request body.
///
/// ## Example
///
/// ```swift
/// .headers {
///     ContentType("application/json")
/// }
/// ```
public struct ContentType: HeaderProtocol {
    public let key = "Content-Type"
    public let value: String

    /// Creates a Content-Type header with the specified media type.
    ///
    /// - Parameter value: The media type (e.g., "application/json", "application/xml")
    public init(_ value: String) {
        self.value = value
    }
}

/// The Accept HTTP header indicating the media types the client can handle.
///
/// Use this header to specify which response formats your application can process.
///
/// ## Example
///
/// ```swift
/// .headers {
///     Accept("application/json")
/// }
/// ```
public struct Accept: HeaderProtocol {
    public let key = "Accept"
    public let value: String

    /// Creates an Accept header with the specified media type.
    ///
    /// - Parameter value: The media type (e.g., "application/json", "text/html")
    public init(_ value: String) {
        self.value = value
    }
}

/// The X-Api-Key HTTP header for API key authentication.
///
/// Many APIs use this custom header for API key-based authentication.
///
/// ## Example
///
/// ```swift
/// .headers {
///     XApiKey("your-api-key-here")
/// }
/// ```
public struct XApiKey: HeaderProtocol {
    public let key = "X-Api-Key"
    public let value: String

    /// Creates an X-Api-Key header with the specified API key.
    ///
    /// - Parameter value: The API key value
    public init(_ value: String) {
        self.value = value
    }
}

/// The User-Agent HTTP header identifying the client application.
///
/// Use this header to identify your application to the server.
///
/// ## Example
///
/// ```swift
/// .headers {
///     UserAgent("MyApp/1.0")
/// }
/// ```
public struct UserAgent: HeaderProtocol {
    public let key = "User-Agent"
    public let value: String

    /// Creates a User-Agent header with the specified value.
    ///
    /// - Parameter value: The user agent string (e.g., "MyApp/1.0", "MyApp/1.0 (iOS 15.0)")
    public init(_ value: String) {
        self.value = value
    }
}
