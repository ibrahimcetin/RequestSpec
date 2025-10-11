//
//  Headers.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

public protocol HeaderProtocol {
    var key: String { get }
    var value: String { get }
}

public struct Header: HeaderProtocol {
    public let key: String
    public let value: String

    public init(_ key: String, value: String) {
        self.key = key
        self.value = value
    }
}

// MARK: - Common Headers

/// Authorization header
public struct Authorization: HeaderProtocol {
    public let key = "Authorization"
    public let value: String

    public init(_ value: String) {
        self.value = value
    }
}

/// Content-Type header
public struct ContentType: HeaderProtocol {
    public let key = "Content-Type"
    public let value: String

    public init(_ value: String) {
        self.value = value
    }
}

/// Accept header
public struct Accept: HeaderProtocol {
    public let key = "Accept"
    public let value: String

    public init(_ value: String) {
        self.value = value
    }
}

/// X-Api-Key header
public struct XApiKey: HeaderProtocol {
    public let key = "X-Api-Key"
    public let value: String

    public init(value: String) {
        self.value = value
    }
}

/// User-Agent header
public struct UserAgent: HeaderProtocol {
    public let key = "User-Agent"
    public let value: String

    public init(_ value: String) {
        self.value = value
    }
}
