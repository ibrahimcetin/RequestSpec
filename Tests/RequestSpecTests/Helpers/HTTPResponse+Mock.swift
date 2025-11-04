//
//  HTTPResponse+Mock.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 1.11.2025.
//

import Foundation
import RequestSpec

extension HTTPResponse {
    /// Create a mock HTTPResponse for testing
    static func mock(
        body: Body,
        url: URL = URL(string: "https://api.example.com")!,
        statusCode: Int = 200,
        headers: [String: String]? = nil
    ) -> HTTPResponse<Body> {
        let httpResponse = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: "HTTP/1.1",
            headerFields: headers
        )!
        return HTTPResponse(body: body, originalResponse: httpResponse)
    }
}

extension HTTPURLResponse {
    convenience init(url: URL, statusCode: Int, headers: [String: String]? = nil) {
        self.init(url: url, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: headers)!
    }
}
