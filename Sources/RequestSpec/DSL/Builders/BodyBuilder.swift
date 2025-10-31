//
//  BodyBuilder.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

/// Result builder for constructing request body
@resultBuilder
public enum BodyBuilder {
    public static func buildBlock(_ component: (any Encodable)?) -> (any Encodable)? {
        component
    }

    public static func buildExpression(_ expression: (any Encodable)?) -> (any Encodable)? {
        expression
    }

    public static func buildEither(first component: (any Encodable)?) -> (any Encodable)? {
        component
    }

    public static func buildEither(second component: (any Encodable)?) -> (any Encodable)? {
        component
    }

    public static func buildOptional(_ component: (any Encodable)??) -> (any Encodable)? {
        component.flatMap { $0 }
    }

    /// Only one Encodable body is allowed; do not combine multiple body values.
    @available(*, unavailable, message: "Only one Encodable body is allowed in a request.")
    public static func buildBlock(_ components: (any Encodable)?...) -> (any Encodable)? {
        fatalError()
    }

    //    public static func buildBlock(_ components: [any KeyValuePair & Encodable]...) -> any Encodable {
    //        components
    //    }
}
