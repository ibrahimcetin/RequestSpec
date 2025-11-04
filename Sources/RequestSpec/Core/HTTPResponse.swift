//
//  Response.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 11.10.2025.
//

import Foundation

public struct HTTPResponse<Body> {
    /// The response body
    public let body: Body

    /// The original HTTP response
    public let originalResponse: HTTPURLResponse

    /// Initialize a response with body and original HTTP response
    public init(body: Body, originalResponse: HTTPURLResponse) {
        self.body = body
        self.originalResponse = originalResponse
    }

    /// The status code of the response
    public var statusCode: Int {
        originalResponse.statusCode
    }

    /// The headers of the response
    public var headers: [String: String] {
        originalResponse.allHeaderFields.reduce(into: [:]) { result, pair in
            if let key = pair.key as? String, let value = pair.value as? String {
                result[key] = value
            }
        }
    }
}

extension HTTPResponse {
    public enum Status {
        case information
        case success
        case redirection
        case clientError
        case serverError
        case unknown
    }

    /// The status of the response
    ///
    /// - information: 100-199
    /// - success: 200-299
    /// - redirection: 300-399
    /// - clientError: 400-499
    /// - serverError: 500-599
    /// - unknown: other
    public var status: Status {
        switch statusCode {
        case 100...199:
            return .information
        case 200...299:
            return .success
        case 300...399:
            return .redirection
        case 400...499:
            return .clientError
        case 500...599:
            return .serverError
        default:
            return .unknown
        }
    }
}
