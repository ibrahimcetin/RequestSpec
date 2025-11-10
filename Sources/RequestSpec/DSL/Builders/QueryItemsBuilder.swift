//
//  QueryItemsBuilder.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

/// A result builder for constructing URL query parameters in a declarative way.
///
/// `QueryItemsBuilder` enables the declarative syntax used in the ``Request/queryItems(_:)`` modifier,
/// allowing you to specify multiple query parameters with support for conditionals, optionals, and loops.
///
/// ## Example
///
/// ```swift
/// .queryItems {
///     Item("page", value: "1")
///     Item("limit", value: "20")
///
///     if includeMetadata {
///         Item("include", value: "metadata")
///     }
///
///     for filter in filters {
///         Item("filter", value: filter)
///     }
/// }
/// ```
///
/// - Note: You typically don't need to interact with this type directly. It's used automatically
///   when you use the ``Request/queryItems(_:)`` modifier.
///
/// - SeeAlso:
///   - ``Request/queryItems(_:)``
///   - ``QueryItemProtocol``
@resultBuilder
public enum QueryItemsBuilder {
    /// Combines multiple query item components into a single array.
    public static func buildBlock(_ components: [any QueryItemProtocol]...) -> [any QueryItemProtocol] {
        components.flatMap { $0 }
    }

    /// Converts a single query item into an array.
    public static func buildExpression(_ expression: any QueryItemProtocol) -> [any QueryItemProtocol] {
        [expression]
    }

    /// Handles the first branch of an if-else statement.
    public static func buildEither(first component: [any QueryItemProtocol]) -> [any QueryItemProtocol] {
        component
    }

    /// Handles the second branch of an if-else statement.
    public static func buildEither(second component: [any QueryItemProtocol]) -> [any QueryItemProtocol] {
        component
    }

    /// Handles optional query items from if statements without else.
    public static func buildOptional(_ component: [any QueryItemProtocol]?) -> [any QueryItemProtocol] {
        component ?? []
    }

    /// Handles arrays from for-in loops.
    public static func buildArray(_ components: [[any QueryItemProtocol]]) -> [any QueryItemProtocol] {
        components.flatMap { $0 }
    }

    /// Handles void expressions to allow empty lines or comments.
    public static func buildExpression(_ expression: Void) -> [any QueryItemProtocol] {
        []
    }
}
