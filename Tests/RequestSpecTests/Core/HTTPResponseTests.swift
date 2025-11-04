//
//  HTTPResponseTests.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 1.11.2025.
//

import Foundation
import RequestSpec
import Testing

// MARK: - Initialization Tests

@Suite("HTTPResponse Initialization", .tags(.unit, .response))
struct HTTPResponseInitializationTests {
    @Test("Response initializes with body and originalResponse")
    func testResponseInitialization() throws {
        let urlResponse = HTTPURLResponse(url: TestURLs.validBase, statusCode: 200)

        let response = HTTPResponse(body: TestData.sampleResponse, originalResponse: urlResponse)

        #expect(response.body == TestData.sampleResponse)
        #expect(response.originalResponse === urlResponse)
    }

    @Test("Response works with different body types")
    func testDifferentBodyTypes() throws {
        let stringResponse = HTTPResponse(
            body: "text content",
            originalResponse: HTTPURLResponse(url: TestURLs.validBase, statusCode: 200)
        )
        #expect(stringResponse.body == "text content")

        let dataResponse = HTTPResponse(
            body: Data([0x01, 0x02]),
            originalResponse: HTTPURLResponse(url: TestURLs.validBase, statusCode: 200)
        )
        #expect(dataResponse.body == Data([0x01, 0x02]))

        let structResponse = HTTPResponse(
            body: TestUser(name: "Alice", email: "alice@example.com"),
            originalResponse: HTTPURLResponse(url: TestURLs.validBase, statusCode: 200)
        )
        #expect(structResponse.body.name == "Alice")
    }
}

// MARK: - Status Code Tests

@Suite("HTTPResponse Status Code", .tags(.unit, .response))
struct HTTPResponseStatusCodeTests {
    @Test(
        "statusCode property returns correct value",
        arguments: [
            (200, 200),
            (201, 201),
            (404, 404),
            (500, 500),
        ])
    func testStatusCodeProperty(input: Int, expected: Int) throws {
        let urlResponse = HTTPURLResponse(url: TestURLs.validBase, statusCode: input)
        let response = HTTPResponse(body: "", originalResponse: urlResponse)

        #expect(response.statusCode == expected)
    }

    @Test("statusCode reflects originalResponse")
    func testStatusCodeReflectsOriginal() throws {
        let urlResponse = HTTPURLResponse(
            url: TestURLs.validBase, statusCode: 418, httpVersion: "HTTP/1.1", headerFields: nil)!
        let response = HTTPResponse(body: "I'm a teapot", originalResponse: urlResponse)

        #expect(response.statusCode == 418)
        #expect(response.statusCode == response.originalResponse.statusCode)
    }
}

// MARK: - Headers Tests

@Suite("HTTPResponse Headers", .tags(.unit, .response))
struct HTTPResponseHeadersTests {
    @Test("headers property returns all header fields")
    func testHeadersProperty() throws {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer token123",
        ]
        let urlResponse = HTTPURLResponse(
            url: TestURLs.validBase,
            statusCode: 200,
            headers: headers
        )
        let response = HTTPResponse(body: "", originalResponse: urlResponse)

        let responseHeaders = response.headers
        #expect(responseHeaders["Content-Type"] == "application/json")
        #expect(responseHeaders["Authorization"] == "Bearer token123")
    }

    @Test("headers property returns empty dict when no headers")
    func testEmptyHeaders() throws {
        let urlResponse = HTTPURLResponse(
            url: TestURLs.validBase, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        let response = HTTPResponse(body: "", originalResponse: urlResponse)

        #expect(response.headers.isEmpty)
    }

    @Test("headers reflect originalResponse allHeaderFields")
    func testHeadersReflectOriginal() throws {
        let headers = ["X-Custom-Header": "value"]
        let urlResponse = HTTPURLResponse(
            url: TestURLs.validBase,
            statusCode: 200,
            httpVersion: "HTTP/1.1",
            headerFields: headers
        )!
        let response = HTTPResponse(body: "", originalResponse: urlResponse)

        #expect(response.headers.count == response.originalResponse.allHeaderFields.count)
    }
}

// MARK: - Status Enum Tests

@Suite("HTTPResponse Status Enum - Information", .tags(.unit, .response))
struct HTTPResponseStatusInformationTests {
    @Test(
        "status returns .information for 100-199",
        arguments: [
            100, 101, 102, 150, 199,
        ])
    func testInformationStatus(statusCode: Int) throws {
        let urlResponse = HTTPURLResponse(url: TestURLs.validBase, statusCode: statusCode)
        let response = HTTPResponse(body: "", originalResponse: urlResponse)

        #expect(response.status == .information)
    }
}

@Suite("HTTPResponse Status Enum - Success", .tags(.unit, .response))
struct HTTPResponseStatusSuccessTests {
    @Test(
        "status returns .success for 200-299",
        arguments: [
            200, 201, 202, 204, 250, 299,
        ])
    func testSuccessStatus(statusCode: Int) throws {
        let urlResponse = HTTPURLResponse(url: TestURLs.validBase, statusCode: statusCode)
        let response = HTTPResponse(body: "", originalResponse: urlResponse)

        #expect(response.status == .success)
    }
}

@Suite("HTTPResponse Status Enum - Redirection", .tags(.unit, .response))
struct HTTPResponseStatusRedirectionTests {
    @Test(
        "status returns .redirection for 300-399",
        arguments: [
            300, 301, 302, 304, 307, 308, 350, 399,
        ])
    func testRedirectionStatus(statusCode: Int) throws {
        let urlResponse = HTTPURLResponse(url: TestURLs.validBase, statusCode: statusCode)
        let response = HTTPResponse(body: "", originalResponse: urlResponse)

        #expect(response.status == .redirection)
    }
}

@Suite("HTTPResponse Status Enum - Client Error", .tags(.unit, .response))
struct HTTPResponseStatusClientErrorTests {
    @Test(
        "status returns .clientError for 400-499",
        arguments: [
            400, 401, 403, 404, 418, 429, 450, 499,
        ])
    func testClientErrorStatus(statusCode: Int) throws {
        let urlResponse = HTTPURLResponse(url: TestURLs.validBase, statusCode: statusCode)
        let response = HTTPResponse(body: "", originalResponse: urlResponse)

        #expect(response.status == .clientError)
    }
}

@Suite("HTTPResponse Status Enum - Server Error", .tags(.unit, .response))
struct HTTPResponseStatusServerErrorTests {
    @Test(
        "status returns .serverError for 500-599",
        arguments: [
            500, 501, 502, 503, 504, 550, 599,
        ])
    func testServerErrorStatus(statusCode: Int) throws {
        let urlResponse = HTTPURLResponse(url: TestURLs.validBase, statusCode: statusCode)
        let response = HTTPResponse(body: "", originalResponse: urlResponse)

        #expect(response.status == .serverError)
    }
}

@Suite("HTTPResponse Status Enum - Unknown", .tags(.unit, .response))
struct HTTPResponseStatusUnknownTests {
    @Test(
        "status returns .unknown for codes outside standard ranges",
        arguments: [
            0, 1, 50, 99, 600, 700, 999, 1000,
        ])
    func testUnknownStatus(statusCode: Int) throws {
        let urlResponse = HTTPURLResponse(url: TestURLs.validBase, statusCode: statusCode)
        let response = HTTPResponse(body: "", originalResponse: urlResponse)

        #expect(response.status == .unknown)
    }
}

// MARK: - Edge Case Tests

@Suite("HTTPResponse Edge Cases", .tags(.unit, .response))
struct HTTPResponseEdgeCaseTests {
    @Test(
        "Response handles boundary status codes correctly",
        arguments: [(Int, HTTPResponseStatus)]([
            (99, .unknown),
            (100, .information),
            (199, .information),
            (200, .success),
            (299, .success),
            (300, .redirection),
            (399, .redirection),
            (400, .clientError),
            (499, .clientError),
            (500, .serverError),
            (599, .serverError),
            (600, .unknown),
        ])
    )
    func testBoundaryStatusCodes(statusCode: Int, expectedStatus: HTTPResponseStatus) throws {
        let urlResponse = HTTPURLResponse(url: TestURLs.validBase, statusCode: statusCode)
        let response = HTTPResponse(body: "", originalResponse: urlResponse)
        #expect(response.status == expectedStatus, "Status code \(statusCode) should be \(expectedStatus)")
    }

    @Test("Response with nil body works correctly")
    func testNilBodyResponse() throws {
        struct NilBodyType: Codable {
            // Empty struct
        }

        let urlResponse = HTTPURLResponse(
            url: TestURLs.validBase, statusCode: 204, httpVersion: "HTTP/1.1", headerFields: nil)!
        let response = HTTPResponse(body: NilBodyType(), originalResponse: urlResponse)

        #expect(response.statusCode == 204)
        #expect(response.status == .success)
    }

    @Test("Response preserves all header field types")
    func testHeaderFieldTypes() throws {
        let headers = [
            "Content-Length": "1024",
            "Date": "Mon, 01 Nov 2025 00:00:00 GMT",
            "Cache-Control": "no-cache",
        ]

        let urlResponse = HTTPURLResponse(
            url: TestURLs.validBase,
            statusCode: 200,
            headers: headers
        )
        let response = HTTPResponse(body: "", originalResponse: urlResponse)

        #expect(response.headers["Content-Length"] == "1024")
        #expect(response.headers["Date"] == "Mon, 01 Nov 2025 00:00:00 GMT")
        #expect(response.headers["Cache-Control"] == "no-cache")
    }
}

// MARK: - Integration Tests

@Suite("HTTPResponse Integration", .tags(.integration, .response))
struct HTTPResponseIntegrationTests {
    @Test("Response works with complex body type")
    func testComplexBodyType() throws {
        struct ComplexResponse: Codable, Equatable {
            let id: Int
            let user: TestUser
            let metadata: [String: String]
            let tags: [String]
        }

        let body = ComplexResponse(
            id: 42,
            user: TestUser(name: "Bob", email: "bob@example.com"),
            metadata: ["version": "1.0", "source": "api"],
            tags: ["important", "verified"]
        )

        let urlResponse = HTTPURLResponse(
            url: TestURLs.validBase,
            statusCode: 200,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Type": "application/json"]
        )!

        let response = HTTPResponse(body: body, originalResponse: urlResponse)

        #expect(response.body.id == 42)
        #expect(response.body.user.name == "Bob")
        #expect(response.body.metadata["version"] == "1.0")
        #expect(response.body.tags.contains("important"))
        #expect(response.statusCode == 200)
        #expect(response.status == .success)
    }

    @Test("Response properties work together correctly")
    func testPropertiesCombination() throws {
        let headers = [
            "Content-Type": "application/json",
            "X-Request-ID": "abc123",
        ]

        let urlResponse = HTTPURLResponse(
            url: TestURLs.validBase,
            statusCode: 201,
            httpVersion: "HTTP/1.1",
            headerFields: headers
        )!

        let response = HTTPResponse(
            body: TestData.sampleResponse,
            originalResponse: urlResponse
        )

        // All properties should work together
        #expect(response.body == TestData.sampleResponse)
        #expect(response.statusCode == 201)
        #expect(response.status == .success)
        #expect(response.headers["Content-Type"] == "application/json")
        #expect(response.headers["X-Request-ID"] == "abc123")
    }
}
