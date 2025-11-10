//
//  Decoder.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 11.10.2025.
//

import Foundation

/// A protocol for decoding data into Swift types.
///
/// `Decoder` provides a unified interface for decoding response data in ``NetworkService``.
/// 
/// The library provides a default conformance for `JSONDecoder`, allowing you to use
/// standard JSON decoding out of the box.
///
/// Conform custom decoder types to this protocol if you need to support other data formats
/// like XML, Property Lists, or custom serialization formats.
///
/// - SeeAlso: ``NetworkService``
public protocol Decoder {
    /// Decodes data into the specified type.
    ///
    /// - Parameters:
    ///   - type: The type to decode into
    ///   - from: The data to decode
    /// - Returns: A decoded instance of the specified type
    /// - Throws: An error if decoding fails
    func decode<T>(_ type: T.Type, from: Data) throws -> T where T: Decodable
}

/// Conformance of `JSONDecoder` to the `Decoder` protocol.
///
/// This allows `JSONDecoder` to be used directly as a decoder in ``NetworkService``.
extension JSONDecoder: Decoder {}
