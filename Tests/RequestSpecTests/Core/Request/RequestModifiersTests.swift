//
//  RequestModifiersTests.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 10.10.2025.
//

import Foundation
import RequestSpec
import Testing

// MARK: - Headers Modifier Tests

@Suite("Headers Modifier Tests", .tags(.unit, .modifiers, .dsl))
struct HeadersModifierTests {
    @Test("headers() modifier adds single header")
    func testHeadersModifierSingleHeader() {
        let request = Get<String>("users")
            .headers {
                Header("Authorization", value: "Bearer token")
            }

        #expect(request.components.headers.count == 1)
        #expect(request.components.headers["Authorization"] == "Bearer token")
    }

    @Test("headers() modifier adds multiple headers")
    func testHeadersModifierMultipleHeaders() {
        let request = Get<String>("users")
            .headers {
                Header("Authorization", value: "Bearer token")
                Header("Accept", value: "application/json")
            }

        #expect(request.components.headers.count == 2)
        #expect(request.components.headers["Authorization"] == "Bearer token")
        #expect(request.components.headers["Accept"] == "application/json")
    }

    @Test("headers() modifier uses convenience header types")
    func testHeadersModifierConvenienceTypes() {
        let request = Get<Never>("users")
            .headers {
                Authorization("Bearer token123")
                ContentType("application/json")
                Accept("application/json")
            }

        #expect(request.components.headers.count == 3)
        #expect(request.components.headers["Authorization"] == "Bearer token123")
        #expect(request.components.headers["Content-Type"] == "application/json")
        #expect(request.components.headers["Accept"] == "application/json")
    }

    @Test("headers() modifier supports conditional headers (only if statement)")
    func testHeadersModifierIfCondition() {
        let includeAuth = true

        let request = Get<String>("users")
            .headers {
                if includeAuth {
                    Authorization("Bearer token")
                }
            }

        #expect(request.components.headers.count == 1)
        #expect(request.components.headers["Authorization"] == "Bearer token")
    }

    @Test("headers() modifier supports conditional headers (if-else statement)")
    func testHeadersModifierIfElseCondition() {
        struct User: RequestSpec {
            let useAuthToken: Bool

            var request: Get<String> {
                Get("users")
                    .headers {
                        if useAuthToken {
                            Authorization("Bearer token")
                        } else {
                            Header("X-Anonymous", value: "true")
                        }
                    }
            }
        }

        let requestWithToken = User(useAuthToken: true)
        #expect(requestWithToken.request.components.headers.count == 1)
        #expect(requestWithToken.request.components.headers["Authorization"] == "Bearer token")

        let requestWithAnonymous = User(useAuthToken: false)
        #expect(requestWithAnonymous.request.components.headers.count == 1)
        #expect(requestWithAnonymous.request.components.headers["X-Anonymous"] == "true")
    }

    @Test("headers() modifier supports loops")
    func testHeadersModifierLoops() {
        let customHeaders = ["X-Custom-1": "Value1", "X-Custom-2": "Value2"]

        let request = Get<String>("users")
            .headers {
                for (key, value) in customHeaders {
                    Header(key, value: value)
                }
            }

        #expect(request.components.headers.count == 2)
        #expect(request.components.headers["X-Custom-1"] == "Value1")
        #expect(request.components.headers["X-Custom-2"] == "Value2")
    }

    @Test("headers() modifier can be called multiple times")
    func testMultipleHeadersModifierCalls() {
        let request = Get<String>("users")
            .headers {
                Authorization("Bearer token")
            }
            .headers {
                Accept("application/json")
            }

        // Both headers should be present
        #expect(request.components.headers["Authorization"] == "Bearer token")
        #expect(request.components.headers["Accept"] == "application/json")
    }

    @Test("headers() modifier supports common header types")
    func testHeadersModifierCommonHeaderTypes() {
        let request = Get<String>("users")
            .headers {
                Authorization("Bearer token123")
                ContentType("application/json")
                Accept("application/json")
                XApiKey("api-key-123")
                UserAgent("RequestSpec/1.0")
                Header("Custom-Header", value: "custom-value")
            }

        #expect(request.components.headers.count == 6)
        #expect(request.components.headers["Authorization"] == "Bearer token123")
        #expect(request.components.headers["Content-Type"] == "application/json")
        #expect(request.components.headers["Accept"] == "application/json")
        #expect(request.components.headers["X-Api-Key"] == "api-key-123")
        #expect(request.components.headers["User-Agent"] == "RequestSpec/1.0")
        #expect(request.components.headers["Custom-Header"] == "custom-value")
    }

    @Test("headers() modifier supports void-returning functions like logging")
    func testHeadersModifierWithVoidReturningFunctions() {
        var loggedMessage = ""

        func logMessage(_ message: String) {
            loggedMessage = message
        }

        let request = Get<String>("users")
            .headers {
                Authorization("Bearer token")
                Accept("application/json")
                // Void-returning function
                logMessage("Headers added")
            }

        #expect(request.components.headers.count == 2)
        #expect(request.components.headers["Authorization"] == "Bearer token")
        #expect(request.components.headers["Accept"] == "application/json")
        #expect(loggedMessage == "Headers added")
    }
}

// MARK: - Query Items Modifier Tests

@Suite("Query Items Modifier Tests", .tags(.unit, .modifiers, .dsl))
struct QueryItemsModifierTests {
    @Test("queryItems() modifier adds single query item")
    func testQueryItemsModifierSingleItem() {
        let request = Get<String>("users")
            .queryItems {
                Item("page", value: "1")
            }

        #expect(request.components.queryItems.count == 1)
        #expect(request.components.queryItems[0].name == "page")
        #expect(request.components.queryItems[0].value == "1")
    }

    @Test("queryItems() modifier adds multiple query items")
    func testQueryItemsModifierMultipleItems() {
        let request = Get<String>("users")
            .queryItems {
                Item("page", value: "1")
                Item("limit", value: "10")
            }

        #expect(request.components.queryItems.count == 2)
        #expect(request.components.queryItems[0].name == "page")
        #expect(request.components.queryItems[0].value == "1")
        #expect(request.components.queryItems[1].name == "limit")
        #expect(request.components.queryItems[1].value == "10")
    }

    @Test("queryItems() modifier supports conditional items (only if statement)")
    func testQueryItemsModifierIfCondition() {
        let includeFilter = true

        let request = Get<String>("users")
            .queryItems {
                Item("page", value: "1")
                if includeFilter {
                    Item("filter", value: "active")
                }
            }

        #expect(request.components.queryItems.count == 2)
        #expect(request.components.queryItems[1].name == "filter")
    }

    @Test("queryItems() modifier supports conditional items (if-else statement)")
    func testQueryItemsModifierIfElseCondition() {
        struct User: RequestSpec {
            let includeFilter: Bool

            var request: Get<String> {
                Get("users")
                    .queryItems {
                        Item("page", value: "1")
                        if includeFilter {
                            Item("filter", value: "active")
                        } else {
                            Item("filter", value: "inactive")
                        }
                    }
            }
        }

        let requestWithFilter = User(includeFilter: true)
        #expect(requestWithFilter.request.components.queryItems.count == 2)
        #expect(requestWithFilter.request.components.queryItems[1].name == "filter")
        #expect(requestWithFilter.request.components.queryItems[1].value == "active")

        let requestWithoutFilter = User(includeFilter: false)
        #expect(requestWithoutFilter.request.components.queryItems.count == 2)
        #expect(requestWithoutFilter.request.components.queryItems[1].name == "filter")
        #expect(requestWithoutFilter.request.components.queryItems[1].value == "inactive")
    }

    @Test("queryItems() modifier supports loops")
    func testQueryItemsModifierLoops() {
        let tags = ["swift", "testing"]

        let request = Get<String>("search")
            .queryItems {
                for tag in tags {
                    Item("tag", value: tag)
                }
            }

        #expect(request.components.queryItems.count == 2)
        #expect(request.components.queryItems[0].value == "swift")
        #expect(request.components.queryItems[1].value == "testing")
    }

    @Test("queryItems() modifier supports void-returning functions like logging")
    func testQueryItemsModifierWithVoidReturningFunctions() {
        var loggedMessage = ""

        func logMessage(_ message: String) {
            loggedMessage = message
        }

        let request = Get<String>("users")
            .queryItems {
                Item("page", value: "1")
                logMessage("Query items added")
            }

        #expect(request.components.queryItems.count == 1)
        #expect(request.components.queryItems[0].name == "page")
        #expect(request.components.queryItems[0].value == "1")
        #expect(loggedMessage == "Query items added")
    }
}

// MARK: - Body Modifier Tests

@Suite("Body Modifier Tests", .tags(.unit, .modifiers, .dsl))
struct BodyModifierTests {
    @Test("body() modifier encodes Codable object")
    func testBodyModifierEncodesObject() {
        let user = TestUser(name: "John", email: "john@example.com")

        let request = Post<TestResponse>("users")
            .body {
                user
            }

        #expect(request.components.body != nil)
        #expect(request.components.headers["Content-Type"] == "application/json")
    }

    @Test("body() modifier handles nil body")
    func testBodyModifierHandlesNil() {
        let request = Post<TestResponse>("users")
            .body {
                nil
            }

        #expect(request.components.body == nil)
    }

    @Test("body() modifier supports conditional body (only if statement)")
    func testBodyModifierConditionalBody() throws {
        let includeBody = true
        let user = TestUser(name: "John", email: "john@example.com")

        let request = Post<TestResponse>("users")
            .body {
                if includeBody {
                    user
                }
            }

        let data = try #require(request.components.body)
        #expect(try JSONDecoder().decode(TestUser.self, from: data) == user)
    }

    @Test(
        "body() modifier supports conditional body (if-else statement)",
        arguments: [(true, TestData.sampleUser), (false, TestData.sampleUserAlternative)],
    )
    func testBodyModifierConditionalBodyIfElse(condition: Bool, expected: TestUser) throws {
        let request = Post<TestResponse>("users")
            .body {
                if condition {
                    TestData.sampleUser
                } else {
                    TestData.sampleUserAlternative
                }
            }

        let data = try #require(request.components.body)
        let decoded = try JSONDecoder().decode(TestUser.self, from: data)
        #expect(decoded == expected)
    }

    @Test("body() modifier uses custom encoder")
    func testBodyModifierCustomEncoder() {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        let user = TestUser(name: "John", email: "john@example.com")

        let request = Post<TestResponse>("users")
            .body(encoder: encoder) {
                user
            }

        #expect(request.components.body != nil)
    }
}

// MARK: - Configuration Modifier Tests

@Suite("Configuration Modifier Tests", .tags(.unit, .modifiers))
struct ConfigurationModifierTests {
    @Test("timeout() modifier sets timeout value")
    func testTimeoutModifier() {
        let request = Get<String>("users")
            .timeout(30)

        #expect(request.components.timeout == 30)
    }

    @Test("timeout() modifier can be chained")
    func testTimeoutModifierChaining() {
        let request = Get<String>("users")
            .timeout(15)
            .headers {
                Accept("application/json")
            }

        #expect(request.components.timeout == 15)
        #expect(request.components.headers["Accept"] == "application/json")
    }

    @Test("cachePolicy() modifier sets cache policy")
    func testCachePolicyModifier() {
        let request = Get<String>("users")
            .cachePolicy(.reloadIgnoringLocalCacheData)

        #expect(request.components.cachePolicy == .reloadIgnoringLocalCacheData)
    }

    @Test("cachePolicy() modifier can be chained")
    func testCachePolicyModifierChaining() {
        let request = Get<String>("users")
            .cachePolicy(.returnCacheDataDontLoad)
            .timeout(45)

        #expect(request.components.cachePolicy == .returnCacheDataDontLoad)
        #expect(request.components.timeout == 45)
    }

    @Test("allowsCellularAccess() modifier sets cellular access")
    func testAllowsCellularAccessModifier() {
        let request = Get<String>("users")
            .allowsCellularAccess(false)

        #expect(request.components.allowsCellularAccess == false)
    }

    @Test("allowsCellularAccess() modifier can be chained")
    func testAllowsCellularAccessModifierChaining() {
        let request = Get<String>("users")
            .allowsCellularAccess(false)
            .timeout(45)

        #expect(request.components.allowsCellularAccess == false)
        #expect(request.components.timeout == 45)
    }
}

// MARK: - Modifier Chaining Tests

@Suite("Modifier Chaining Tests", .tags(.integration, .modifiers))
struct ModifierChainingTests {
    @Test("All modifiers can be chained together")
    func testAllModifiersChaining() {
        let user = TestUser(name: "Jane", email: "jane@example.com")

        let request = Post<TestResponse>("api", "users")
            .headers {
                Authorization("Bearer token")
                ContentType("application/json")
            }
            .queryItems {
                Item("notify", value: "true")
            }
            .body {
                user
            }
            .timeout(30)
            .cachePolicy(.reloadIgnoringLocalCacheData)
            .allowsCellularAccess(false)

        // Verify all modifications applied
        #expect(request.components.headers["Authorization"] == "Bearer token")
        #expect(request.components.queryItems.count == 1)
        #expect(request.components.body != nil)
        #expect(request.components.timeout == 30)
        #expect(request.components.cachePolicy == .reloadIgnoringLocalCacheData)
        #expect(request.components.allowsCellularAccess == false)
    }

    @Test("Modifiers preserve request immutability")
    func testModifiersPreserveImmutability() {
        let request1 = Get<String>("users")
        let request2 = request1.timeout(30)
        let request3 = request2.headers {
            Accept("application/json")
        }

        // Original request should be unchanged
        #expect(request1.components.timeout == 60)  // default
        #expect(request1.components.headers.isEmpty)

        // Second request should have timeout but no headers
        #expect(request2.components.timeout == 30)
        #expect(request2.components.headers.isEmpty)

        // Third request should have both
        #expect(request3.components.timeout == 30)
        #expect(!request3.components.headers.isEmpty)
    }

    @Test("Multiple calls to same modifier override previous values")
    func testMultipleModifierCallsOverride() {
        let request = Get<String>("users")
            .timeout(10)
            .timeout(20)
            .timeout(30)

        #expect(request.components.timeout == 30)
    }
}
