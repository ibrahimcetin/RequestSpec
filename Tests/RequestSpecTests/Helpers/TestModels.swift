//
//  TestModels.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 10.10.2025.
//

import Foundation
import Testing

// MARK: - Test Models

/// Simple test model for encoding/decoding
struct TestUser: Codable, Equatable {
    let name: String
    let email: String
}

/// Simple test response model
struct TestResponse: Codable, Equatable {
    let message: String
}

// MARK: - Test URLs

enum TestURLs {
    static let validBase = URL(string: "https://api.example.com")!
    static let validBaseWithPath = URL(string: "https://api.example.com/v1")!
    static let localhost = URL(string: "http://localhost:8080")!
}

// MARK: - Test Data

enum TestData {
    static let sampleUser = TestUser(name: "John Doe", email: "john@example.com")
    static let sampleUserAlternative = TestUser(name: "Joe Doe", email: "joe@example.com")
    static let sampleResponse = TestResponse(message: "Success")

    static func jsonData<T: Encodable>(_ value: T) -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return try! encoder.encode(value)
    }
}
