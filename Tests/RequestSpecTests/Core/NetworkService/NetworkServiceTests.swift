//
//  NetworkServiceTests.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 1.11.2025.
//

import Foundation
import RequestSpec
import Testing

// MARK: - Test Model

struct Echo: Codable {
    let method: String
    let data: String

    var headers: [String: String]? = nil
}

/// Test service protocol showing recommended pattern
protocol EchoServiceProtocol: NetworkService {
    func getEcho(id: String) async throws -> Echo
    func postEcho(data: any Encodable & Sendable) async throws -> Echo
    func deleteEcho(id: String) async throws -> Echo
}

/// RequestSpec for get request - preferred over direct Request usage
struct GetEchoRequest: RequestSpec {
    let id: String

    var request: Get<Echo> {
        Get("anything", "echo")
            .headers {
                Authorization("Bearer token")
                ContentType("application/json")
            }
            .queryItems {
                Item("id", value: id)
            }
    }
}

/// RequestSpec for post request
struct PostEchoRequest: RequestSpec {
    let data: any Encodable & Sendable

    var request: Post<Echo> {
        Post("anything", "echo")
            .headers {
                ContentType("application/json")
                Accept("application/json")
                Authorization("Bearer token")
            }
            .body {
                data
            }
    }
}

/// RequestSpec for delete request
struct DeleteEchoRequest: RequestSpec {
    let id: String

    var request: Delete<Echo> {
        Delete("anything", "echo")
            .headers {
                ContentType("application/json")
            }
            .queryItems {
                Item("id", value: id)
            }
    }
}

/// Service implementation using RequestSpec (recommended pattern)
final class EchoService: EchoServiceProtocol {
    let baseURL = URL(string: "https://httpbin.org")!

    func getEcho(id: String) async throws -> Echo {
        let response = try await send(GetEchoRequest(id: id))
        return response.body
    }

    func postEcho(data: any Encodable & Sendable) async throws -> Echo {
        let response = try await send(PostEchoRequest(data: data))
        return response.body
    }

    func deleteEcho(id: String) async throws -> Echo {
        let response = try await send(DeleteEchoRequest(id: id))
        return response.body
    }
}

/// Mock service implementation for testing
final class MockEchoService: EchoServiceProtocol {
    let baseURL = URL(string: "https://httpbin.org")!

    func getEcho(id: String) async throws -> Echo {
        return Echo(method: "GET", data: "")
    }

    func postEcho(data: any Encodable & Sendable) async throws -> Echo {
        return Echo(method: "POST", data: "")
    }

    func deleteEcho(id: String) async throws -> Echo {
        return Echo(method: "DELETE", data: "")
    }
}

@Suite("Real NetworkService Tests", .tags(.integration, .networkService))
struct RealNetworkServiceTests {
    @Test("Echo Service getEcho request test")
    func testEchoServiceGetEchoRequest() async throws {
        let service = EchoService()

        // Service internally uses GetEchoRequest
        let echo = try await service.getEcho(id: "123")

        #expect(echo.method == "GET")
        #expect(echo.data == "")
    }

    @Test("Echo Service postEcho request test")
    func testEchoServicePostEchoRequest() async throws {
        let service = EchoService()
        let echo = try await service.postEcho(data: "123")

        #expect(echo.method == "POST")
        #expect(echo.data == "\"123\"")
    }

    @Test("Echo Service deleteEcho request test")
    func testEchoServiceDeleteEchoRequest() async throws {
        let service = EchoService()
        let echo = try await service.deleteEcho(id: "123")

        #expect(echo.method == "DELETE")
        #expect(echo.data == "")
    }

    @Test("RequestSpec can be used independently")
    func testRequestSpecDirectUsage() async throws {
        let service = EchoService()
        let spec = GetEchoRequest(id: "456")

        // Send GetEchoRequest directly
        let response = try await service.send(spec)

        #expect(response.statusCode == 200)
        #expect(response.body.method == "GET")
        #expect(response.body.data == "")
    }
}

@Suite("Response Types Demo", .tags(.integration, .networkService))
struct ResponseTypesDemoTests {
    @Test("Decode JSON response")
    func testJSONResponse() async throws {
        let service = EchoService()
        let request = Get<Echo>("anything", "get")

        let response = try await service.send(request)

        #expect(response.body.method == "GET")
        #expect(response.body.data == "")
    }

    @Test("Get String response")
    func testStringResponse() async throws {
        let service = EchoService()
        let request = Get<String>("html")

        let response = try await service.send(request)

        #expect(response.body.contains("html"))
        #expect(response.statusCode == 200)
    }

    @Test("Get Data response")
    func testDataResponse() async throws {
        let service = EchoService()
        let request = Get<Data>("bytes/100")

        let response = try await service.send(request)

        #expect(response.body.count == 100)
        #expect(response.statusCode == 200)
    }
}

@Suite("HTTP Status Codes", .tags(.integration, .networkService))
struct HTTPStatusCodesTests {

    @Test("Handle 200 status")
    func test200Status() async throws {
        let service = EchoService()
        let request = Get<String>("status", "200")

        let response = try await service.send(request)

        #expect(response.statusCode == 200)
        #expect(response.status == .success)
    }

    @Test("Handle 404 status")
    func test404Status() async throws {
        let service = EchoService()
        let request = Get<String>("status", "404")

        let response = try await service.send(request)

        #expect(response.statusCode == 404)
        #expect(response.status == .clientError)
    }

    @Test("Handle 500 status")
    func test500Status() async throws {
        let service = EchoService()
        let request = Get<String>("status/500")

        let response = try await service.send(request)

        #expect(response.statusCode == 500)
        #expect(response.status == .serverError)
    }
}

@Suite("NetworkService Direct Request Tests", .tags(.integration, .networkService))
struct NetworkServiceDirectRequestTests {
    @Test("Send GET request and receive response")
    func testBasicGetRequest() async throws {
        let service = EchoService()
        let request = Get<Echo>("anything", "get")

        let response = try await service.send(request)

        #expect(response.statusCode == 200)
        #expect(response.body.method == "GET")
    }

    @Test("Send GET request with headers")
    func testGetRequestWithHeaders() async throws {
        let service = EchoService()
        let request = Get<Echo>("anything", "get")
            .headers {
                Header("X-Custom-Header", value: "test-value")
            }

        let response = try await service.send(request)

        #expect(response.statusCode == 200)
        #expect(response.body.headers?["X-Custom-Header"] == "test-value")
    }

    @Test("Send POST request with JSON body")
    func testPostRequestWithBody() async throws {
        let service = EchoService()

        let request = Post<Echo>("anything", "post")
            .headers {
                ContentType("application/json")
            }
            .body {
                "Test data"
            }

        let response = try await service.send(request)

        #expect(response.statusCode == 200)
        #expect(response.body.method == "POST")
        #expect(response.body.data == "\"Test data\"")
    }
}

@Suite("Decoding Error Handling", .tags(.integration, .networkService))
struct DecodingErrorHandlingTests {
    @Test("Decoding error includes everything we need")
    func testDecodingErrorIncludesEverythingWeNeed() async throws {
        let service = EchoService()
        let request = Get<TestUser>("json")

        do {
            _ = try await service.send(request)
            Issue.record("Expected decoding error but succeeded")
        } catch RequestSpecError.decodingFailed(let response, let underlyingError) {
            #expect(response.statusCode == 200)

            #expect(underlyingError is DecodingError)

            #expect(response.body.count > 0)
            #expect(String(decoding: response.body, as: UTF8.self).contains("title"))
        } catch {
            Issue.record("Expected decodingFailed error but got \(error)")
        }
    }
    @Test("Successful decoding with custom type works normally")
    func testSuccessfulDecodingWorks() async throws {
        let service = EchoService()
        let request = Get<Echo>("anything", "test")

        // Should succeed without throwing
        let response = try await service.send(request)

        #expect(response.statusCode == 200)
        #expect(response.body.method == "GET")
    }

    @Test("String and Data types never throw decoding errors")
    func testStringAndDataTypesAlwaysSucceed() async throws {
        let service = EchoService()

        // String type with any status code
        let stringRequest = Get<String>("status", "500")
        let stringResponse = try await service.send(stringRequest)
        #expect(stringResponse.statusCode == 500)

        // Data type with any status code
        let dataRequest = Get<Data>("status", "404")
        let dataResponse = try await service.send(dataRequest)
        #expect(dataResponse.statusCode == 404)
    }
}
