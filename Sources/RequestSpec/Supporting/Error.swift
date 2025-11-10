//
//  Error.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

public enum RequestSpecError: Error, Sendable {
    case invalidURL

    case decodingFailed(response: HTTPResponse<Data>, underlyingError: any Error)
}
