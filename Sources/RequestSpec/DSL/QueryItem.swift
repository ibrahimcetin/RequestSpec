//
//  QueryItem.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

/// A protocol for types that represent URL query parameters.
///
/// Conform to this protocol to create custom query item types that can be used with the
/// ``Request/queryItems(_:)`` modifier. The library provides a generic ``Item`` type
/// for standard query parameters.
///
/// - SeeAlso: ``Request/queryItems(_:)``
public protocol QueryItemProtocol {
    /// The query parameter name.
    var key: String { get }

    /// The query parameter value.
    ///
    /// A `nil` value represents a query parameter without a value (e.g., `?flag` instead of `?flag=value`).
    var value: String? { get }
}

/// A URL query parameter with a key and optional value.
///
/// Use this type to add query parameters to your requests. Query parameters are appended to the
/// URL as key-value pairs after a `?` character.
///
/// ## Example
///
/// ```swift
/// .queryItems {
///     Item("page", value: "1")
///     Item("limit", value: "20")
///     Item("sort", value: "name")
/// }
/// ```
///
/// This produces a URL like: `/endpoint?page=1&limit=20&sort=name`
public struct Item: QueryItemProtocol {
    public let key: String
    public let value: String?

    /// Creates a query parameter with the specified key and value.
    ///
    /// - Parameters:
    ///   - key: The query parameter name
    ///   - value: The query parameter value, or `nil` for a flag-style parameter
    public init(_ key: String, value: String?) {
        self.key = key
        self.value = value
    }
}
