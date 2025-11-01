//
//  Decoder.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 11.10.2025.
//

import Foundation

public protocol Decoder {
    func decode<T>(_ type: T.Type, from: Data) throws -> T where T: Decodable
}

extension JSONDecoder: Decoder {}
