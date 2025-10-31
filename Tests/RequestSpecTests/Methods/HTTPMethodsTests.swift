//
//  HTTPMethodsTests.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 10.10.2025.
//

import Foundation
import RequestSpec
import Testing

// MARK: - HTTP Method Tests

@Suite("HTTP Method Tests", .tags(.unit, .httpMethods))
struct HTTPMethodTests {
    // MARK: - GET Method Tests

    @Test("Get request has correct HTTP method")
    func testGetRequestMethod() {
        let request = Get<String>("users")
        #expect(request.method == .get)
        #expect(request.method.rawValue == "GET")
    }

    @Test("Get request stores path components correctly")
    func testGetRequestPathComponents() {
        let request = Get<String>("users", "123", "posts")
        #expect(request.pathComponents == ["users", "123", "posts"])
    }

    @Test("Get request initializes with empty components")
    func testGetRequestInitialComponents() {
        let request = Get<String>("users")
        #expect(request.components.headers.isEmpty)
        #expect(request.components.queryItems.isEmpty)
        #expect(request.components.body == nil)
        #expect(request.components.timeout == 60)
        #expect(request.components.cachePolicy == .useProtocolCachePolicy)
        #expect(request.components.allowsCellularAccess == true)
    }

    @Test("Get request can be created with variadic path components")
    func testGetRequestVariadicInit() {
        let request = Get<String>("api", "v1", "users", "profile")
        #expect(request.pathComponents.count == 4)
    }

    // MARK: - POST Method Tests

    @Test("Post request has correct HTTP method")
    func testPostRequestMethod() {
        let request = Post<TestResponse>("users")
        #expect(request.method == .post)
        #expect(request.method.rawValue == "POST")
    }

    @Test("Post request stores path components correctly")
    func testPostRequestPathComponents() {
        let request = Post<TestResponse>("api", "users")
        #expect(request.pathComponents == ["api", "users"])
    }

    @Test("Post request initializes with empty components")
    func testPostRequestInitialComponents() {
        let request = Post<TestResponse>("users")
        #expect(request.components.headers.isEmpty)
        #expect(request.components.queryItems.isEmpty)
        #expect(request.components.body == nil)
    }

    // MARK: - PUT Method Tests

    @Test("Put request has correct HTTP method")
    func testPutRequestMethod() {
        let request = Put<TestResponse>("users", "123")
        #expect(request.method == .put)
        #expect(request.method.rawValue == "PUT")
    }

    @Test("Put request stores path components correctly")
    func testPutRequestPathComponents() {
        let request = Put<TestResponse>("users", "123")
        #expect(request.pathComponents == ["users", "123"])
    }

    @Test("Put request initializes with empty components")
    func testPutRequestInitialComponents() {
        let request = Put<TestResponse>("users", "123")
        #expect(request.components.headers.isEmpty)
        #expect(request.components.queryItems.isEmpty)
        #expect(request.components.body == nil)
    }

    // MARK: - PATCH Method Tests

    @Test("Patch request has correct HTTP method")
    func testPatchRequestMethod() {
        let request = Patch<TestResponse>("users", "123")
        #expect(request.method == .patch)
        #expect(request.method.rawValue == "PATCH")
    }

    @Test("Patch request stores path components correctly")
    func testPatchRequestPathComponents() {
        let request = Patch<TestResponse>("users", "123")
        #expect(request.pathComponents == ["users", "123"])
    }

    @Test("Patch request initializes with empty components")
    func testPatchRequestInitialComponents() {
        let request = Patch<TestResponse>("users", "123")
        #expect(request.components.headers.isEmpty)
        #expect(request.components.queryItems.isEmpty)
        #expect(request.components.body == nil)
    }

    // MARK: - DELETE Method Tests

    @Test("Delete request has correct HTTP method")
    func testDeleteRequestMethod() {
        let request = Delete<TestResponse>("users", "123")
        #expect(request.method == .delete)
        #expect(request.method.rawValue == "DELETE")
    }

    @Test("Delete request stores path components correctly")
    func testDeleteRequestPathComponents() {
        let request = Delete<TestResponse>("users", "123")
        #expect(request.pathComponents == ["users", "123"])
    }

    @Test("Delete request initializes with empty components")
    func testDeleteRequestInitialComponents() {
        let request = Delete<TestResponse>("users", "123")
        #expect(request.components.headers.isEmpty)
        #expect(request.components.queryItems.isEmpty)
        #expect(request.components.body == nil)
    }

    // MARK: - HEAD Method Tests

    @Test("Head request has correct HTTP method")
    func testHeadRequestMethod() {
        let request = Head<TestResponse>("users", "123")
        #expect(request.method == .head)
        #expect(request.method.rawValue == "HEAD")
    }

    @Test("Head request stores path components correctly")
    func testHeadRequestPathComponents() {
        let request = Head<TestResponse>("users", "123")
        #expect(request.pathComponents == ["users", "123"])
    }

    @Test("Head request initializes with empty components")
    func testHeadRequestInitialComponents() {
        let request = Head<TestResponse>("users", "123")
        #expect(request.components.headers.isEmpty)
        #expect(request.components.queryItems.isEmpty)
        #expect(request.components.body == nil)
    }

    // MARK: - OPTIONS Method Tests

    @Test("Options request has correct HTTP method")
    func testOptionsRequestMethod() {
        let request = Options<TestResponse>("users")
        #expect(request.method == .options)
        #expect(request.method.rawValue == "OPTIONS")
    }

    @Test("Options request stores path components correctly")
    func testOptionsRequestPathComponents() {
        let request = Options<TestResponse>("api", "users")
        #expect(request.pathComponents == ["api", "users"])
    }

    @Test("Options request initializes with empty components")
    func testOptionsRequestInitialComponents() {
        let request = Options<TestResponse>("users")
        #expect(request.components.headers.isEmpty)
        #expect(request.components.queryItems.isEmpty)
        #expect(request.components.body == nil)
    }

    // MARK: - Request ID Tests

    @Test("Each request has a unique ID")
    func testRequestUniqueIDs() {
        let request1 = Get<String>("users")
        let request2 = Get<String>("users")

        // IDs are generated each time, so they should be different
        #expect(request1.id != request2.id)
    }
}

// MARK: - Method Comparison Tests

@Suite("Method Comparison Tests", .tags(.unit, .httpMethods))
struct MethodComparisonTests {
    @Test("Different HTTP methods are distinct")
    func testHTTPMethodsAreDistinct() {
        let methods: [HTTPMethod] = [.get, .post, .put, .patch, .delete, .head, .options]

        // Verify all methods are unique
        let uniqueMethods = Set(methods)
        #expect(uniqueMethods.count == 7)
    }

    @Test("HTTP methods have correct raw values")
    func testHTTPMethodRawValues() {
        #expect(HTTPMethod.get.rawValue == "GET")
        #expect(HTTPMethod.post.rawValue == "POST")
        #expect(HTTPMethod.put.rawValue == "PUT")
        #expect(HTTPMethod.patch.rawValue == "PATCH")
        #expect(HTTPMethod.delete.rawValue == "DELETE")
        #expect(HTTPMethod.head.rawValue == "HEAD")
        #expect(HTTPMethod.options.rawValue == "OPTIONS")
    }

    @Test("All method types conform to Request protocol")
    func testRequestProtocolConformance() {
        // Get
        let getRequest: any Request = Get<String>("users")
        #expect(getRequest.method == .get)

        // Post
        let postRequest: any Request = Post<TestResponse>("users")
        #expect(postRequest.method == .post)

        // Put
        let putRequest: any Request = Put<TestResponse>("users", "123")
        #expect(putRequest.method == .put)

        // Patch
        let patchRequest: any Request = Patch<TestResponse>("users", "123")
        #expect(patchRequest.method == .patch)

        // Delete
        let deleteRequest: any Request = Delete<TestResponse>("users", "123")
        #expect(deleteRequest.method == .delete)

        // Head
        let headRequest: any Request = Head<TestResponse>("users", "123")
        #expect(headRequest.method == .head)

        // Options
        let optionsRequest: any Request = Options<TestResponse>("users")
        #expect(optionsRequest.method == .options)
    }
}

// MARK: - Method Integration Tests

@Suite("Method Integration Tests", .tags(.integration, .httpMethods))
struct MethodIntegrationTests {
    @Test("All HTTP method types can build URLRequest")
    func testAllMethodsBuildURLRequest() throws {
        let baseURL = URL(string: "https://api.example.com")!

        // Get
        _ = try Get<String>("users").urlRequest(baseURL: baseURL)

        // Post
        _ = try Post<TestResponse>("users").urlRequest(baseURL: baseURL)

        // Put
        _ = try Put<TestResponse>("users", "123").urlRequest(baseURL: baseURL)

        // Patch
        _ = try Patch<TestResponse>("users", "123").urlRequest(baseURL: baseURL)

        // Delete
        _ = try Delete<TestResponse>("users", "123").urlRequest(baseURL: baseURL)

        // Head
        _ = try Head<TestResponse>("users", "123").urlRequest(baseURL: baseURL)

        // Options
        _ = try Options<TestResponse>("users").urlRequest(baseURL: baseURL)

        // If we got here, all methods successfully built URLRequests
    }

    @Test("HTTP methods work with modifiers")
    func testMethodsWorkWithModifiers() throws {
        let baseURL = URL(string: "https://api.example.com")!

        let request = Post<TestResponse>("users")
            .headers {
                ContentType("application/json")
            }
            .queryItems {
                Item("format", value: "json")
            }
            .timeout(30)

        let urlRequest = try request.urlRequest(baseURL: baseURL)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.absoluteString.contains("format=json") == true)
        #expect(urlRequest.timeoutInterval == 30)
    }
}
