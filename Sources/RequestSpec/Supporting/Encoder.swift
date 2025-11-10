//
//  Encoder.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

import Foundation

/// A protocol for encoding Swift types into data.
///
/// `Encoder` provides a unified interface for encoding request bodies when using the
/// ``Request/body(encoder:_:)`` modifier.
///
/// The library provides a default conformance for
/// `JSONEncoder`, allowing you to use standard JSON encoding out of the box.
///
/// Conform custom encoder types to this protocol if you need to support other data formats
/// like XML, Property Lists, or custom serialization formats.
///
/// - SeeAlso: ``Request/body(encoder:_:)``
public protocol Encoder {
    /// Encodes a value into data.
    ///
    /// - Parameter value: The value to encode
    /// - Returns: The encoded data
    /// - Throws: An error if encoding fails
    func encode<T>(_ value: T) throws -> Data where T: Encodable
}

/// Conformance of `JSONEncoder` to the `Encoder` protocol.
///
/// This allows `JSONEncoder` to be used directly as an encoder in request body modifiers.
extension JSONEncoder: Encoder {}
