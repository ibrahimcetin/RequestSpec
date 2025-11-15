# RequestSpec

[![](https://github.com/ibrahimcetin/RequestSpec/actions/workflows/swift.yml/badge.svg)](https://github.com/ibrahimcetin/RequestSpec/actions/workflows/swift.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fibrahimcetin%2FRequestSpec%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ibrahimcetin/RequestSpec)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fibrahimcetin%2FRequestSpec%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/ibrahimcetin/RequestSpec)

RequestSpec is a lightweight Swift library that provides a fluent, declarative API for building HTTP requests, making your networking code more **maintainable**, **organized**, and **testable**. It is built on top of `URLRequest` and fully **interoperable** with existing libraries such as [`URLSession`](https://developer.apple.com/documentation/foundation/urlsession), [`Alamofire`](https://github.com/Alamofire/Alamofire) and more. You can easily integrate it into your existing network layer.

> [!WARNING]
> **📢 Migrating from 0.1.x?** The `RequestSpec.body` property has been renamed to `request` in 0.2.0 for better clarity. Just rename `body` to `request` in your RequestSpec implementations and you're good to go.

```swift
import RequestSpec

struct GetUserRequest: RequestSpec {
    let userId: Int
    let authToken: String?
    let includeFields: [String]

    var request: Get<User> {
        Get("users", "\(userId)")
            .headers {
                ContentType("application/json")
                Accept("application/json")

                if let token = authToken {
                    Authorization("Bearer \(token)")

                    logger.info("Adding Authorization header")
                }
            }
            .queryItems {
                Item("page", value: "1")

                for field in includeFields {
                    Item("fields", value: field)
                }
            }
            .body {
                User(id: userId, name: "John Doe")
            }
    }
}
```

Furthermore, RequestSpec provides its own implementation of `NetworkService` protocol, which can be used to send requests and easily build network services. It is a [lightweight protocol](./Sources/RequestSpec/Core/NetworkService/NetworkService.swift) built on top of `URLSession`, providing a convenient way to send requests and handle responses.

```swift
protocol UserServiceProtocol: NetworkService {
    func getUser(userId: Int) async throws -> User
}

final class UserService: UserServiceProtocol {
    var baseURL: URL = URL(string: "https://api.example.com")!

    func getUser(userId: Int) async throws -> User {
        let request = GetUserRequest(userId: userId)
        let response = try await send(request)
        return response.body
    }
}
```

Its just that easy to build and use.

## What is RequestSpec?

* [What is RequestSpec?](#what-is-requestspec)
* [Examples](#examples)
* [Basic usage](#basic-usage)
  * [Approach 1: Using RequestSpec protocol (Structured)](#approach-1-using-requestspec-protocol-structured)
  * [Approach 2: Direct Request use (Quick)](#approach-2-direct-request-use-quick)
  * [Understanding Request vs RequestSpec](#understanding-request-vs-requestspec)
  * [Advanced modifier features](#advanced-modifier-features)
* [Installation](#installation)
* [Documentation](#documentation)
* [License](#license)

## What is RequestSpec?

RequestSpec is a lightweight Swift library built on top of `URLRequest` that provides a declarative API for building HTTP requests. Instead of manually constructing `URLRequest` objects with repetitive boilerplate, you define your requests using a clean, expressive syntax that makes your networking code more maintainable and less error-prone.

This library provides a few core tools that can be used to build networking layers of varying purpose and complexity. It provides compelling patterns that you can follow to solve many problems you encounter day-to-day when building network clients, such as:

* **Type safety**
  <br> Define your requests and responses using Swift's type system. Generic request types ensure your responses are properly typed, eliminating casting and reducing runtime errors.

* **Declarative syntax**
  <br> Build requests using a fluent, SwiftUI-like syntax with result builders. Define paths, query parameters, headers, and body in a clear, readable way.

* **Composition**
  <br> Requests are composable values. Add headers, query items, and body data using chainable modifiers. Share common configurations across requests.

* **Interoperability**
  <br> RequestSpec builds on top of `URLRequest`, making it compatible with any networking library. Use it with `URLSession`, `Alamofire`, or any other HTTP client you prefer.

* **Testability**
  <br> Requests are pure value types that can be easily inspected and tested. Generate cURL commands for debugging, test request construction without making network calls, and mock responses with ease.

* **Built-in networking**
  <br> While interoperable with other libraries, RequestSpec provides its own `NetworkService` protocol implementation for common use cases, complete with async/await support and automatic JSON encoding/decoding.

## Examples

This repo comes with examples to demonstrate how to solve common and complex problems with RequestSpec. Check out the [Examples](./Examples) directory to see them all, including:

* [RequestSpecExample](./Examples/RequestSpecExample) - A comprehensive example showing all HTTP methods (GET, POST, PUT, PATCH, DELETE) using the JSONPlaceholder API
* [URLSessionInteroperabilityExample](./Examples/URLSessionInteroperabilityExample) - Demonstrates how to use RequestSpec with existing URLSession implementation
* [AlamofireInteroperabilityExample](./Examples/AlamofireInteroperabilityExample) - Demonstrates how to use RequestSpec with existing Alamofire implementation

## Basic Usage

RequestSpec offers two approaches for building HTTP requests, each suited to different use cases. Both approaches leverage the same underlying `Request` types (`Get`, `Post`, `Put`, `Patch`, `Delete`, `Head`, `Options`) but differ in how you structure and organize your code.

### Approach 1: Using RequestSpec protocol (Structured)

The `RequestSpec` protocol approach is ideal for building organized, maintainable networking layers. This pattern is recommended for production applications where you want clear separation of concerns, reusable request definitions, and a consistent architecture.

**When to use this approach:**
- Building a complete API client with many endpoints
- Need reusable, parameterized request definitions
- Working with a team on a production application
- Want to organize requests into logical groupings
- Need to easily test request construction

**Example:**

```swift
import RequestSpec

// Define a reusable request specification
struct GetUserRequest: RequestSpec {
    let userId: Int

    var request: Get<User> {
        Get("users", "\(userId)")
            .headers {
                Authorization("Bearer \(token)")
                ContentType("application/json")
                Accept("application/json")
            }
            .queryItems {
                Item("include", value: "profile")
            }
            .timeout(10)
    }
}

// Create a service using the NetworkService protocol
final class UserService: NetworkService {
    var baseURL: URL = URL(string: "https://api.example.com")!

    func getUser(userId: Int) async throws -> User {
        let request = GetUserRequest(userId: userId)
        let response = try await send(request)
        return response.body
    }
}

// Usage
let service = UserService()
let user = try await service.getUser(userId: 123)
```

**Key benefits of this approach:**
- Clear request definitions that can be reused across your codebase
- Easy to parameterize requests with custom data
- Service protocols promote testability (mock the protocol in tests)
- Requests are separate from their execution (better separation of concerns)
- IDE autocomplete helps discover available requests

### Approach 2: Direct Request use (Quick)

The direct request approach is perfect for quick prototyping, scripts, or simple networking tasks. You create and send requests inline without defining a `RequestSpec` type.

**When to use this approach:**
- Rapid prototyping or experimentation
- One-off scripts or command-line tools
- Simple applications with few network calls
- When request reusability isn't a priority
- Quick API testing or debugging

**Example:**

```swift
import RequestSpec

// Define a simple service
final class QuickService: NetworkService {
    var baseURL: URL = URL(string: "https://api.example.com")!

    func getUser(userId: Int) async throws -> User {
        // Create and send the request directly
        let request = Get<User>("users", "\(userId)")
            .headers {
                Authorization("Bearer \(token)")
                Accept("application/json")
            }

        let response = try await send(request)
        return response.body
    }
}

// Or even more concise for one-off calls:
func fetchUser(_ id: Int) async throws -> User {
    let service = QuickService()
    return try await service.send(
        Get<User>("users", "\(id)")
            .headers { Accept("application/json") }
    ).body
}
```

**Key benefits of this approach:**
- Less boilerplate for simple cases
- Faster to write for one-off requests
- More flexible for dynamic request construction
- Good for learning and experimentation

### Understanding Request vs RequestSpec

The library provides two related but distinct protocols: `Request` and `RequestSpec`. Understanding the difference helps you choose the right approach for your needs.

**Request Protocol:**

`Request` is the core protocol that represents an actual HTTP request. All concrete request types (`Get`, `Post`, `Put`, etc.) conform to this protocol.

```swift
public protocol Request: Identifiable, Sendable {
    associatedtype ResponseBody: Decodable

    var id: UUID { get }
    var method: HTTPMethod { get }
    var pathComponents: [String] { get }
    var components: RequestComponents { get set }
}
```

**Key characteristics:**
- Represents a concrete HTTP request ready to be executed
- Has a defined HTTP method (GET, POST, etc.)
- Contains all request data (path, headers, body, query items)
- Examples: `Get<User>`, `Post<CreateUserResponse>`, `Delete<Data>`

**RequestSpec Protocol:**

`RequestSpec` is a wrapper protocol that lets you define reusable request specifications with custom parameters and logic.

```swift
public protocol RequestSpec: Sendable {
    associatedtype RequestType: Request

    var request: RequestType { get }
}
```

**Key characteristics:**
- Wraps a `Request` in a named, reusable type
- Allows you to add stored properties (parameters, configuration)
- Provides a clean abstraction for complex requests
- Can have custom initializers and computed properties
- The `request` property generates the actual `Request`

**When to use each:**

Use `Request` directly when:
- Making quick, one-off network calls
- Prototyping or experimenting
- The request is simple and unlikely to be reused
- You want minimal boilerplate

Use `RequestSpec` when:
- Building a structured API client
- The request needs parameters or configuration
- You want to reuse the request definition in multiple places
- You're building production code with a team
- You want clear documentation of your API surface

**Example comparison:**

```swift
// Direct Request usage - quick and simple
let response = try await service.send(
    Get<User>("users", "123")
)

// RequestSpec usage - organized and reusable
struct GetUserRequest: RequestSpec {
    let userId: String

    var request: Get<User> {
        Get("users", userId)
    }
}

let response = try await service.send(
    GetUserRequest(userId: "123")
)
```

Both approaches ultimately create a `Request` that gets sent over the network. The choice is about code organization and your specific needs.

### Complete example

Here's a more complete example showing POST request with JSON body:

```swift
import RequestSpec

// Define your models
struct CreatePostInput: Codable {
    let title: String
    let body: String
    let userId: Int
}

struct Post: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}

// Using RequestSpec approach
struct CreatePostRequest: RequestSpec {
    let input: CreatePostInput

    var request: Post<Post> {
        Post("posts")
            .body {
                input
            }
            .headers {
                ContentType("application/json")
                Accept("application/json")
            }
            .timeout(15)
    }
}

// Define your service
protocol PostServiceProtocol: NetworkService {
    func createPost(title: String, body: String, userId: Int) async throws -> Post
}

final class PostService: PostServiceProtocol {
    var baseURL: URL = URL(string: "https://jsonplaceholder.typicode.com")!

    func createPost(title: String, body: String, userId: Int) async throws -> Post {
        let input = CreatePostInput(title: title, body: body, userId: userId)
        let request = CreatePostRequest(input: input)
        let response = try await send(request)
        return response.body
    }
}

// Usage
let service = PostService()
let newPost = try await service.createPost(
    title: "Hello RequestSpec",
    body: "This is my first post",
    userId: 1
)
print("Created post with ID: \(newPost.id)")
```

### Available HTTP Methods

RequestSpec provides type-safe implementations for all standard HTTP methods:

```swift
Get<ResponseType>("path")          // GET request
Post<ResponseType>("path")         // POST request
Put<ResponseType>("path")          // PUT request
Patch<ResponseType>("path")        // PATCH request
Delete<ResponseType>("path")       // DELETE request
Head<ResponseType>("path")         // HEAD request
Options<ResponseType>("path")      // OPTIONS request
```

Each request type supports the full range of modifiers:

```swift
Get<User>("users", "123")
    .headers {
        Authorization("Bearer token")
        Accept("application/json")
        UserAgent("MyApp/1.0")
    }
    .queryItems {
        Item("include", value: "profile")
        Item("fields", value: "name,email")
    }
    .timeout(10)
    .cachePolicy(.reloadIgnoringLocalCacheData)
    .allowsCellularAccess(true)
```

### Request modifiers

All request types support the following modifiers:

* `.headers { }` - Add HTTP headers using result builder syntax
* `.queryItems { }` - Add URL query parameters
* `.body { }` - Set the request body (POST, PUT, PATCH)
* `.timeout(_:)` - Set request timeout in seconds
* `.cachePolicy(_:)` - Set cache policy
* `.allowsCellularAccess(_:)` - Control cellular access

### Working with headers

RequestSpec provides type-safe header definitions for common headers:

```swift
.headers {
    Authorization("Bearer abc123")      // Authorization header
    ContentType("application/json")     // Content-Type header
    Accept("application/json")          // Accept header
    UserAgent("MyApp/1.0")             // User-Agent header
    XApiKey("secret-key")              // X-Api-Key header
    Header("Custom-Header", value: "value")  // Custom header
}
```

### Advanced modifier features

RequestSpec's modifiers support conditionals, loops, and void-returning functions, allowing you to dynamically build requests based on runtime conditions. This includes conditional statements (if-else), iterating over collections with for loops, and calling void functions for side effects like logging.

```swift
struct CreateCommentRequest: RequestSpec {
    let authToken: String?
    let includeMetadata: Bool

    let text: String
    let postID: Int
    let attachment: Data?

    let tags: [String]
    let customHeaders: [String: String]

    var request: Post<Comment> {
        Post("comments")
            .headers {
                ContentType("application/json")
                Accept("application/json")

                // Conditional: only add Authorization if token exists
                if let token = authToken {
                    Authorization("Bearer \(token)")

                    // Void function: log Authorization header for debugging
                    logger.info("Adding Authorization header")
                }

                // For loop: add multiple custom headers dynamically
                for (key, value) in customHeaders {
                    Header(key, value: value)

                    // Log custom header for debugging
                    logger.debug("Adding custom header: \(key)")
                }
            }
            .queryItems {
                // Conditional: add metadata parameter if enabled
                if includeMetadata {
                    Item("include", value: "metadata")
                }

                // For loop: add multiple tags as query parameters
                for tag in tags {
                    Item("tag", value: tag)
                }
            }
            .body {
                // Conditional body content with logging
                if let attachment = attachment {
                    let _ = logger.info("Including attachment in request")
                    CommentWithAttachment(text: text, postID: postID, attachment: attachment)
                } else {
                    let _ = logger.info("Sending comment without attachment")
                    CommentInput(text: text, postID: postID)
                }
            }
    }
}
```

### Debugging with cURL

Generate cURL commands for debugging:

```swift
let request = Get<User>("users", "123")
    .headers {
        Authorization("Bearer token")
    }

let curlCommand = try request.cURLDescription(baseURL: baseURL)
print(curlCommand)
// Output:
// $ curl -v \
// -X GET \
// -H "Authorization: Bearer token" \
// "https://api.example.com/users/123"
```

## Installation

You can add RequestSpec to an Xcode project by adding it as a package dependency.

1. From the **File** menu, select **Add Package Dependencies...**
2. Enter "https://github.com/ibrahimcetin/RequestSpec" into the package repository URL text field
3. Depending on how your project is structured:
   - If you have a single application target that needs access to the library, then add **RequestSpec** directly to your application.
   - If you want to use this library from multiple Xcode targets, or mix Xcode targets and SPM targets, you must create a shared framework that depends on **RequestSpec** and then depend on that framework in all of your targets.

### SPM Package.swift

If you want to use RequestSpec in a Swift Package Manager package, add it as a dependency:

```swift
dependencies: [
    .package(url: "https://github.com/ibrahimcetin/RequestSpec", from: "0.2.0")
]
```

Then add the RequestSpec dependency to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "RequestSpec", package: "RequestSpec")
    ]
)
```

## Documentation

RequestSpec is built with clarity and discoverability in mind. The library uses:

* **Protocol-oriented design** - Core functionality is defined through protocols, making the library extensible
* **Generic types** - Type-safe responses eliminate casting and catch errors at compile time
* **Result builders** - SwiftUI-like syntax for headers and query items
* **Comprehensive examples** - Real-world examples in the Examples directory

### Interoperability with other libraries

RequestSpec is designed to work seamlessly with existing networking libraries. Since all requests can be converted to `URLRequest`, you can use RequestSpec with:

**URLSession** (built-in):

```swift
let request = Get<User>("users", "123")
let urlRequest = try request.urlRequest(baseURL: baseURL)
let (data, response) = try await URLSession.shared.data(for: urlRequest)
```

**Alamofire**:

```swift
let request = Get<User>("users", "123")
let urlRequest = try request.urlRequest(baseURL: baseURL)
let response = await AF.request(urlRequest).serializingDecodable(User.self).response
```

See the [AlamofireInteroperabilityExample](./Examples/AlamofireInteroperabilityExample) for a complete example.

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
