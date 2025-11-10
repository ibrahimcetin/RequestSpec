//
//  HeadersBuilder.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

/// A result builder for constructing HTTP headers in a declarative way.
///
/// `HeadersBuilder` enables the declarative syntax used in the ``Request/headers(_:)`` modifier,
/// allowing you to specify multiple headers with support for conditionals, optionals, and loops.
///
/// ## Example
///
/// ```swift
/// .headers {
///     ContentType("application/json")
///     Accept("application/json")
///
///     if let token = authToken {
///         Authorization("Bearer \(token)")
///     }
///
///     for key in apiKeys {
///         Header("X-API-Key", value: key)
///     }
/// }
/// ```
///
/// - Note: You typically don't need to interact with this type directly. It's used automatically
///   when you use the ``Request/headers(_:)`` modifier.
///
/// - SeeAlso:
///   - ``Request/headers(_:)``
///   - ``HeaderProtocol``
@resultBuilder
public enum HeadersBuilder {
    /// Combines multiple header components into a single array.
    public static func buildBlock(_ components: [any HeaderProtocol]...) -> [any HeaderProtocol] {
        components.flatMap { $0 }
    }

    /// Converts a single header into an array.
    public static func buildExpression(_ expression: any HeaderProtocol) -> [any HeaderProtocol] {
        [expression]
    }

    /// Handles the first branch of an if-else statement.
    public static func buildEither(first component: [any HeaderProtocol]) -> [any HeaderProtocol] {
        component
    }

    /// Handles the second branch of an if-else statement.
    public static func buildEither(second component: [any HeaderProtocol]) -> [any HeaderProtocol] {
        component
    }

    /// Handles optional headers from if statements without else.
    public static func buildOptional(_ component: [any HeaderProtocol]?) -> [any HeaderProtocol] {
        component ?? []
    }

    /// Handles arrays from for-in loops.
    public static func buildArray(_ components: [[any HeaderProtocol]]) -> [any HeaderProtocol] {
        components.flatMap { $0 }
    }

    /// Handles void expressions to allow empty lines or comments.
    public static func buildExpression(_ expression: Void) -> [any HeaderProtocol] {
        []
    }
}
