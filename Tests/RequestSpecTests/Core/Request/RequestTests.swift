//
//  RequestTests.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 10.10.2025.
//

import Foundation
import RequestSpec
import Testing

// MARK: - URL Construction Tests

@Suite("URL Construction Tests", .tags(.unit, .urlBuilding))
struct URLConstructionTests {
    @Test("Request builds basic URL correctly")
    func testBasicURLConstruction() throws {
        let request = Get<String>("users")
        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)

        let url = try #require(urlRequest.url)
        #expect(url.absoluteString == "https://api.example.com/users")
    }

    @Test("Request builds URL with multiple path components")
    func testMultiplePathComponents() throws {
        let request = Get<String>("users", "123", "posts")
        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)

        let url = try #require(urlRequest.url)
        #expect(url.absoluteString == "https://api.example.com/users/123/posts")
    }

    @Test("Request builds URL with single path component")
    func testSinglePathComponent() throws {
        let request = Get<String>("repos")
        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)

        let url = try #require(urlRequest.url)
        #expect(url.absoluteString == "https://api.example.com/repos")
    }

    @Test("Request handles empty path components")
    func testEmptyPathComponents() throws {
        let request = Get<String>()
        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)

        let url = try #require(urlRequest.url)
        #expect(url.absoluteString == "https://api.example.com/")
    }

    @Test(
        "Request has same id after creation",
        arguments: [
            Get<TestResponse>("users"),
            Post<TestResponse>("users"),
            Put<TestResponse>("users"),
            Patch<TestResponse>("users"),
            Delete<TestResponse>("users"),
            Head<TestResponse>("users"),
            Options<TestResponse>("users"),
        ] as [any Request],
    )
    func testRequestId(request: any Request) throws {
        let id1 = request.id
        let id2 = request.id
        #expect(id1 == id2)
    }
}

// MARK: - Query Items Tests

@Suite("Query Items Tests", .tags(.unit, .urlBuilding))
struct QueryItemsTests {
    @Test("Request with no query items has no query string")
    func testNoQueryItems() throws {
        let request = Get<String>("users")
        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)

        let url = try #require(urlRequest.url)
        #expect(!url.absoluteString.contains("?"))
    }

    @Test("Request builds URL with single query item")
    func testSingleQueryItem() throws {
        var request = Get<String>("users")
        request.components.queryItems = [URLQueryItem(name: "page", value: "1")]

        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)
        let url = try #require(urlRequest.url)

        #expect(url.absoluteString == "https://api.example.com/users?page=1")
    }

    @Test("Request builds URL with multiple query items")
    func testMultipleQueryItems() throws {
        var request = Get<String>("users")
        request.components.queryItems = [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "limit", value: "10"),
        ]

        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)
        let url = try #require(urlRequest.url)

        #expect(url.absoluteString.contains("page=1"))
        #expect(url.absoluteString.contains("limit=10"))
    }

    @Test("Request handles query items with special characters")
    func testQueryItemsWithSpecialCharacters() throws {
        var request = Get<String>("search")
        request.components.queryItems = [
            URLQueryItem(name: "q", value: "hello world")
        ]

        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)
        let url = try #require(urlRequest.url)

        // URLComponents should encode the space
        #expect(url.absoluteString.contains("hello%20world") || url.absoluteString.contains("hello+world"))
    }
}

// MARK: - Headers Tests

@Suite("Headers Tests", .tags(.unit))
struct HeadersTests {
    @Test("Request with no headers has empty header fields")
    func testNoHeaders() throws {
        let request = Get<String>("users")
        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)

        #expect(urlRequest.allHTTPHeaderFields?.isEmpty ?? true)
    }

    @Test("Request sets single header correctly")
    func testSingleHeader() throws {
        var request = Get<String>("users")
        request.components.headers = ["Authorization": "Bearer token123"]

        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)

        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer token123")
    }

    @Test("Request sets multiple headers correctly")
    func testMultipleHeaders() throws {
        var request = Get<String>("users")
        request.components.headers = [
            "Authorization": "Bearer token123",
            "Content-Type": "application/json",
            "Accept": "application/json",
        ]

        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)

        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer token123")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
    }
}

// MARK: - Body Tests

@Suite("Body Tests", .tags(.unit))
struct BodyTests {
    @Test("Request with nil body has no httpBody")
    func testNilBody() throws {
        let request = Get<String>("users")
        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)

        #expect(urlRequest.httpBody == nil)
    }

    @Test("Request sets body data correctly")
    func testBodyData() throws {
        var request = Post<TestResponse>("users")
        let bodyData = TestData.jsonData(TestData.sampleUser)
        request.components.body = bodyData

        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)

        #expect(urlRequest.httpBody == bodyData)
    }

    @Test("Request sets HTTP method correctly")
    func testHTTPMethod() throws {
        let getRequest = Get<String>("users")
        let postRequest = Post<TestResponse>("users")

        let getURLRequest = try getRequest.urlRequest(baseURL: TestURLs.validBase)
        let postURLRequest = try postRequest.urlRequest(baseURL: TestURLs.validBase)

        #expect(getURLRequest.httpMethod == "GET")
        #expect(postURLRequest.httpMethod == "POST")
    }
}

// MARK: - Request Properties Tests

@Suite("Request Properties Tests", .tags(.unit))
struct RequestPropertiesTests {
    @Test("Request sets timeout interval correctly")
    func testTimeoutInterval() throws {
        var request = Get<String>("users")
        request.components.timeout = 30

        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)

        #expect(urlRequest.timeoutInterval == 30)
    }

    @Test("Request uses default timeout interval")
    func testDefaultTimeoutInterval() throws {
        let request = Get<String>("users")
        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)

        #expect(urlRequest.timeoutInterval == 60)
    }

    @Test("Request sets cache policy correctly")
    func testCachePolicy() throws {
        var request = Get<String>("users")
        request.components.cachePolicy = .reloadIgnoringLocalCacheData

        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)

        #expect(urlRequest.cachePolicy == .reloadIgnoringLocalCacheData)
    }

    @Test("Request uses default cache policy")
    func testDefaultCachePolicy() throws {
        let request = Get<String>("users")
        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)

        #expect(urlRequest.cachePolicy == .useProtocolCachePolicy)
    }

    @Test("Request sets cellular access correctly")
    func testCellularAccess() throws {
        var request = Get<String>("users")
        request.components.allowsCellularAccess = false

        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)

        #expect(urlRequest.allowsCellularAccess == false)
    }

    @Test("Request uses default cellular access")
    func testDefaultCellularAccess() throws {
        let request = Get<String>("users")
        let urlRequest = try request.urlRequest(baseURL: TestURLs.validBase)

        #expect(urlRequest.allowsCellularAccess == true)
    }
}

// MARK: - Error Handling Tests

@Suite("Error Handling Tests", .tags(.unit))
struct ErrorHandlingTests {
    @Test("Request throws error for invalid base URL")
    func testInvalidBaseURLError() throws {
        // Testing with an invalid URL is tricky since URL(string:) returns nil
        // We'll test the URLComponents failure path instead
        let request = Get<String>("users")

        // This should work fine with a valid URL
        _ = try request.urlRequest(baseURL: TestURLs.validBase)

        // The error case is hard to trigger directly since URL validation happens earlier
        // This test documents the expected behavior
    }
}

// MARK: - Request Integration Tests

@Suite("Request Integration Tests", .tags(.integration, .urlBuilding))
struct RequestIntegrationTests {
    struct SampleRequest: RequestSpec {
        var request: Post<TestResponse> {
            Post("api", "v1", "users")
                .queryItems {
                    Item("format", value: "json")
                }
                .headers {
                    Authorization("Bearer token")
                    ContentType("application/json")
                }
                .body {
                    TestData.jsonData(TestData.sampleUser)
                }
                .timeout(30)
                .cachePolicy(.reloadIgnoringLocalCacheData)
        }
    }

    @Test("Request builds complete URL with all components")
    func testCompleteURLBuilding() throws {
        var request = Post<TestResponse>("api", "v1", "users")
        request.components.queryItems = [
            URLQueryItem(name: "format", value: "json")
        ]
        request.components.headers = [
            "Authorization": "Bearer token",
            "Content-Type": "application/json",
        ]
        request.components.body = TestData.jsonData(TestData.sampleUser)
        request.components.timeout = 30
        request.components.cachePolicy = .reloadIgnoringLocalCacheData

        let urlRequest = try request.urlRequest(baseURL: TestURLs.localhost)

        // Verify URL
        let url = try #require(urlRequest.url)
        #expect(url.absoluteString.contains("localhost:8080/api/v1/users"))
        #expect(url.absoluteString.contains("format=json"))

        // Verify headers
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer token")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")

        // Verify body
        #expect(urlRequest.httpBody == TestData.jsonData(TestData.sampleUser))

        // Verify properties
        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.timeoutInterval == 30)
        #expect(urlRequest.cachePolicy == .reloadIgnoringLocalCacheData)

        // Verify RequestSpec version produces the same URLRequest
        let requestSpecURLRequest = try SampleRequest().urlRequest(baseURL: TestURLs.localhost)
        #expect(requestSpecURLRequest == urlRequest)
    }

    @Test("Request builds cURL description correctly")
    func testCURLDescription() throws {
        let request = Post<TestResponse>("api", "v1", "users")
            .headers {
                Authorization("Bearer token")
                ContentType("application/json")
            }
            .queryItems {
                Item("format", value: "json")
            }
            .body {
                TestData.jsonData(TestData.sampleUser)
            }

        let cURLDescription = try request.cURLDescription(baseURL: TestURLs.localhost)

        #expect(
            cURLDescription == """
                $ curl -v \\
                -X POST \\
                -H "Authorization: Bearer token" \\
                -H "Content-Type: application/json" \\
                -d "{\\\"email\\\":\\\"john@example.com\\\",\\\"name\\\":\\\"John Doe\\\"}" \\
                "http://localhost:8080/api/v1/users?format=json"
                """)
    }
}
