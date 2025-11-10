//
//  HTTPMethod.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 7.10.2025.
//

/// A type-safe representation of HTTP request methods.
///
/// `HTTPMethod` provides static constants for standard HTTP methods and supports custom methods
/// through its `RawRepresentable` conformance. The library uses this type to ensure type safety
/// when specifying request methods.
///
/// - Note: For most use cases, you'll use the predefined constants like ``get``, ``post``, ``put``, etc.
///   Custom methods are supported for advanced scenarios.
public struct HTTPMethod: RawRepresentable, Equatable, Hashable, Sendable {
    /// The CONNECT method establishes a tunnel to the server.
    public static let connect = HTTPMethod(rawValue: "CONNECT")

    /// The DELETE method deletes the specified resource.
    public static let delete = HTTPMethod(rawValue: "DELETE")

    /// The GET method requests a representation of the specified resource.
    public static let get = HTTPMethod(rawValue: "GET")

    /// The HEAD method requests the headers that would be returned if the resource was requested with GET.
    public static let head = HTTPMethod(rawValue: "HEAD")

    /// The OPTIONS method describes the communication options for the target resource.
    public static let options = HTTPMethod(rawValue: "OPTIONS")

    /// The PATCH method applies partial modifications to a resource.
    public static let patch = HTTPMethod(rawValue: "PATCH")

    /// The POST method submits an entity to the specified resource.
    public static let post = HTTPMethod(rawValue: "POST")

    /// The PUT method replaces all current representations of the target resource.
    public static let put = HTTPMethod(rawValue: "PUT")

    /// The QUERY method is used to query data.
    public static let query = HTTPMethod(rawValue: "QUERY")

    /// The TRACE method performs a message loop-back test along the path to the target resource.
    public static let trace = HTTPMethod(rawValue: "TRACE")

    /// The raw string value of the HTTP method.
    public let rawValue: String

    /// Creates an HTTP method with the specified raw value.
    ///
    /// Use this initializer to create custom HTTP methods beyond the standard ones provided as static constants.
    ///
    /// - Parameter rawValue: The string value of the HTTP method (e.g., "GET", "POST", "CUSTOM")
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
