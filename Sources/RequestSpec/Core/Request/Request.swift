//
//  RequestSpec.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 7.10.2025.
//

import Foundation

/// The base protocol for all HTTP network requests.
///
/// `Request` defines the structure and behavior for making HTTP requests in a type-safe, composable way.
/// Rather than conforming to this protocol directly, you typically use the concrete request types like
/// ``Get``, ``Post``, ``Put``, ``Patch``, or ``Delete``, which implement this protocol with specific HTTP methods.
///
/// ## Usage
///
/// ```swift
/// // Create a GET request with path components
/// let getUserRequest = Get<User>("users", "42")
///
/// // Build a POST request with headers, query items, body, and timeout
/// let createUserRequest = Post<User>("users")
///     .headers {
///         Authorization("Bearer token123")
///         ContentType("application/json")
///         Accept("application/json")
///     }
///     .queryItems {
///         Item("notify", value: "true")
///         Item("source", value: "mobile")
///     }
///     .body {
///         CreateUserInput(name: "John Doe", email: "john@example.com")
///     }
///     .timeout(30)
///
/// // Send the request using NetworkService
/// let response = try await networkService.send(createUserRequest)
/// print("Created user: \(response.body.name)")
/// ```
///
/// - Note: For production applications, it's recommended to wrap your requests in ``RequestSpec``
///   to create reusable, parameterized request definitions.
///
/// - SeeAlso:
///   - ``RequestSpec``
///   - ``Get``
///   - ``Post``
///   - ``Put``
///   - ``Patch``
///   - ``Delete``
///   - ``NetworkService``
public protocol Request: Identifiable, Sendable {
    /// The type of the decoded response body this request expects.
    ///
    /// This associatedtype determines what type will be decoded from the HTTP response body.
    /// It must conform to `Decodable` to support automatic decoding.
    ///
    /// - Note: Use `Data` as the response type if you don't want automatic decoding
    ///   e.g., `Get<Data>("endpoint")`.
    associatedtype ResponseBody: Decodable

    /// A unique identifier for this request instance.
    ///
    /// Each request has a unique ID that can be used for tracking, logging, or request management.
    var id: UUID { get }

    /// The HTTP method for this request (e.g., GET, POST, PUT, DELETE).
    ///
    /// - SeeAlso: ``HTTPMethod``
    var method: HTTPMethod { get }

    /// The path components that make up the request URL path.
    ///
    /// These components are joined with "/" to form the request path. For example,
    /// `["users", "42", "profile"]` becomes `/users/42/profile`.
    var pathComponents: [String] { get }

    /// The configuration components for this request.
    ///
    /// This includes headers, query items, body data, timeout, cache policy, and other request settings.
    ///
    /// - SeeAlso: ``RequestComponents``
    var components: RequestComponents { get set }

    /// Creates a request with the specified path components.
    ///
    /// - Parameter pathComponents: Variadic string parameters that form the URL path
    init(_ pathComponents: String...)
}

// MARK: - URLRequest Builder

extension Request {
    /// Builds a `URLRequest` from this request and a base URL.
    ///
    /// This method constructs a complete `URLRequest` by combining the base URL with the request's
    /// path components, query items, headers, body, and other configuration settings. The resulting
    /// `URLRequest` can be used with `URLSession` or other networking libraries.
    ///
    /// - Parameter baseURL: The base URL to which the request path will be appended
    /// - Returns: A fully configured `URLRequest` ready to be executed
    /// - Throws: ``RequestSpecError/invalidURL`` if the URL cannot be constructed from the components
    public func urlRequest(baseURL: URL) throws(RequestSpecError) -> URLRequest {
        // Build URL
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw RequestSpecError.invalidURL
        }

        // Build path
        let path = "/" + pathComponents.joined(separator: "/")
        urlComponents.path = path

        // Add query items
        if !components.queryItems.isEmpty {
            urlComponents.queryItems = components.queryItems
        }

        guard let url = urlComponents.url else {
            throw RequestSpecError.invalidURL
        }

        // Create URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = components.timeout
        urlRequest.cachePolicy = components.cachePolicy
        urlRequest.allowsCellularAccess = components.allowsCellularAccess
        urlRequest.httpBody = components.body

        // Add headers
        for (key, value) in components.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return urlRequest
    }
}

extension Request {
    /// Generates a cURL command string representation of this request.
    ///
    /// This method creates a cURL command that can be copied and executed in a terminal to replicate
    /// the request. This is useful for debugging, sharing requests with others, or testing APIs manually.
    ///
    /// The generated command includes the HTTP method, headers, body data, and full URL.
    ///
    /// ## Example Output
    ///
    /// ```bash
    /// $ curl -v \
    /// -X POST \
    /// -H "Authorization: Bearer token123" \
    /// -H "Content-Type: application/json" \
    /// -d "{\"name\":\"John\",\"email\":\"john@example.com\"}" \
    /// "https://api.example.com/users"
    /// ```
    ///
    /// - Parameter baseURL: The base URL to construct the full request URL
    /// - Returns: A formatted cURL command string
    /// - Throws: ``RequestSpecError/invalidURL`` if the URL cannot be constructed
    public func cURLDescription(baseURL: URL) throws(RequestSpecError) -> String {
        let request = try urlRequest(baseURL: baseURL)

        guard let url = request.url, let method = request.httpMethod
        else { throw RequestSpecError.invalidURL }

        var components = ["$ curl -v"]

        components.append("-X \(method)")

        let headers = request.allHTTPHeaderFields ?? [:]

        for header in headers.sorted(by: { $0.key < $1.key }) {
            let escapedValue = header.value.replacingOccurrences(of: "\"", with: "\\\"")
            components.append("-H \"\(header.key): \(escapedValue)\"")
        }

        if let httpBodyData = request.httpBody {
            let httpBody = String(decoding: httpBodyData, as: UTF8.self)
            var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
            escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")

            components.append("-d \"\(escapedBody)\"")
        }

        components.append("\"\(url.absoluteString)\"")

        return components.joined(separator: " \\\n")
    }
}
