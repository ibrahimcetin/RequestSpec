//
//  BodyBuilder.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

/// A result builder for constructing request bodies in a declarative way.
///
/// `BodyBuilder` enables the declarative syntax used in the ``Request/body(encoder:_:)`` modifier,
/// allowing you to specify the request body with support for conditionals and optionals.
/// Unlike other builders, only a single body value is allowed per request.
///
/// ## Example
///
/// ```swift
/// .body {
///     CreateUserInput(name: "John", email: "john@example.com")
/// }
/// ```
///
/// - Important: Only one body value is allowed per request. Attempting to provide multiple
///   body values will result in a compile-time error.
///
/// - Note: You typically don't need to interact with this type directly. It's used automatically
///   when you use the ``Request/body(encoder:_:)`` modifier.
///
/// - SeeAlso:
///   - ``Request/body(encoder:_:)``
///   - ``Encoder``
@resultBuilder
public enum BodyBuilder {
    /// Returns the single body component.
    public static func buildBlock(_ component: (any Encodable)?) -> (any Encodable)? {
        component
    }

    /// Converts an encodable value into an optional encodable.
    public static func buildExpression(_ expression: (any Encodable)?) -> (any Encodable)? {
        expression
    }

    /// Handles the first branch of an if-else statement.
    public static func buildEither(first component: (any Encodable)?) -> (any Encodable)? {
        component
    }

    /// Handles the second branch of an if-else statement.
    public static func buildEither(second component: (any Encodable)?) -> (any Encodable)? {
        component
    }

    /// Handles optional bodies from if statements without else.
    public static func buildOptional(_ component: (any Encodable)??) -> (any Encodable)? {
        component.flatMap { $0 }
    }

    /// Prevents multiple body values from being specified.
    ///
    /// This overload is marked unavailable to ensure only a single body can be provided in a request.
    @available(*, unavailable, message: "Only one Encodable body is allowed in a request.")
    public static func buildBlock(_ components: (any Encodable)?...) -> (any Encodable)? {
        fatalError()
    }
}
