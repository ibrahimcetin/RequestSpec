/*
╔═══════════════════════════════════════════════════════════════════════════════════╗
║                                                                                   ║
║                   URLSession + RequestSpec Interoperability                       ║
║                                                                                   ║
╚═══════════════════════════════════════════════════════════════════════════════════╝

This example demonstrates how to use RequestSpec with URLSession for networking.

Why use RequestSpec with URLSession?
• Type-safe request definitions
• Easy to maintain and update requests
• Works with existing URLSession codebases
• No need to adopt additional protocols

┌─────────────────────────────────────────────────────────────────────────────────┐
│ What You'll See:                                                                │
├─────────────────────────────────────────────────────────────────────────────────┤
│ 1. GET request using RequestSpec protocol (Structured)                          │
│ 2. POST request with conditional modifiers                                      │
│ 3. GET request using direct Request (Quick)                                     │
└─────────────────────────────────────────────────────────────────────────────────┘
*/

import Foundation
import RequestSpec

@main
struct URLSessionInteroperabilityExample {
    static func main() async throws {
        let service = JSONPlaceholderService()
        let app = URLSessionApp(service: service)
        try await app.run()
    }
}

// MARK: - App

@MainActor
struct URLSessionApp {
    let service: JSONPlaceholderServiceProtocol

    func run() async throws {
        print("═══════════════════════════════════════")
        print("🚀 URLSession + RequestSpec Examples")
        print("═══════════════════════════════════════\n")

        // Example 1: GET request using RequestSpec protocol (Structured)
        try await fetchPost()

        // Example 2: POST request using RequestSpec protocol (Structured)
        try await createPost()

        // Example 3: GET request using direct Request (Quick)
        try await fetchPostsDirect()

        print("\n═══════════════════════════════════════")
        print("✨ All operations completed!")
        print("═══════════════════════════════════════")
    }

    /// Example 1: GET /posts/1 using RequestSpec protocol (Structured)
    /// Shows how RequestSpec makes URL construction type-safe and reusable
    func fetchPost() async throws {
        let post = try await service.getPost(id: 1)
        print("✓ [Structured] Fetched post: \(post.title)")
    }

    /// Example 2: POST /posts using RequestSpec protocol (Structured)
    /// Shows how RequestSpec handles request bodies elegantly
    /// Also demonstrates if-else usage in modifiers for conditional headers and query items
    func createPost() async throws {
        let newPost = CreatePostInput(
            title: "My New Post",
            body: "This is the content",
            userId: 1
        )
        let created = try await service.createPost(input: newPost)
        print("✓ [Structured + Conditional Modifiers] Created post with ID: \(created.id)")
    }

    /// Example 3: GET /posts using direct Request (Quick)
    /// Shows the quick approach - creating requests inline without RequestSpec wrapper
    func fetchPostsDirect() async throws {
        let posts = try await service.getPostsDirect()
        print("✓ [Quick] Fetched \(posts.count) posts")
    }
}

// MARK: - Service

protocol JSONPlaceholderServiceProtocol: Sendable {
    func getPost(id: Int) async throws -> BlogPost
    func createPost(input: CreatePostInput) async throws -> BlogPost
    func getPostsDirect() async throws -> [BlogPost]
}

final class JSONPlaceholderService: JSONPlaceholderServiceProtocol {
    let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
    let session: URLSession
    let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    /// Example 1: Using RequestSpec protocol (Structured approach)
    /// Create a reusable GetPostRequest and send it with URLSession
    func getPost(id: Int) async throws -> BlogPost {
        let request = GetPostRequest(id: id)

        // Convert RequestSpec to URLRequest
        let urlRequest = try request.urlRequest(baseURL: baseURL)

        // Use URLSession to send the request
        let (data, response) = try await session.data(for: urlRequest)

        // Validate the response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        // Decode the response
        // We can use the ResponseBody type to deserialize the response, this is the same as the BlogPost type
        // but it's more explicit, it's all up to you which one you prefer
        let post = try decoder.decode(GetPostRequest.ResponseBody.self, from: data)

        return post
    }

    /// Example 2: Using RequestSpec protocol (Structured approach)
    /// Create a reusable CreatePostRequest and send it with URLSession
    /// Demonstrates conditional modifiers with authToken and includeDraft parameters
    func createPost(input: CreatePostInput) async throws -> BlogPost {
        let request = CreatePostRequest(
            input: input,
            authToken: "sample-token-123",  // Optional: try nil to see no Authorization header
            includeDraft: true  // Boolean: try false to exclude draft query item
        )

        // Convert RequestSpec to URLRequest
        let urlRequest = try request.urlRequest(baseURL: baseURL)

        // Use URLSession to send the request
        let (data, response) = try await session.data(for: urlRequest)

        // Validate the response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        // Decode the response
        let post = try decoder.decode(BlogPost.self, from: data)

        return post
    }

    /// Example 3: Using direct Request (Quick approach)
    /// Create a Get<[BlogPost]> request inline without defining a RequestSpec struct
    /// This is faster for one-off requests that don't need reusability
    func getPostsDirect() async throws -> [BlogPost] {
        // Create the request inline - no RequestSpec struct needed
        let request = Get<[BlogPost]>("posts")
            .headers {
                Accept("application/json")
            }

        // Convert Request to URLRequest
        let urlRequest = try request.urlRequest(baseURL: baseURL)

        // Use URLSession to send the request
        let (data, response) = try await session.data(for: urlRequest)

        // Validate the response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        // Decode the response
        let posts = try decoder.decode([BlogPost].self, from: data)

        return posts
    }
}

// MARK: - Models

struct BlogPost: Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

struct CreatePostInput: Codable {
    let title: String
    let body: String
    let userId: Int
}

// MARK: - RequestSpec Definitions

/// GET /posts/:id using RequestSpec protocol (Structured approach)
/// The RequestSpec approach gives you type-safety, reusability, and clean URL construction
struct GetPostRequest: RequestSpec {
    let id: Int

    /// The ResponseBody type (``BlogPost`` in this case) documents the expected response
    /// You'll use this type when decoding the URLSession response
    var request: Get<BlogPost> {
        Get("posts", "\(id)")
            .headers {
                Accept("application/json")
            }
            .timeout(10)
    }
}

/// POST /posts using RequestSpec protocol (Structured approach)
/// Shows how easy it is to send JSON bodies with RequestSpec
/// Also demonstrates conditional modifiers using if-else statements
struct CreatePostRequest: RequestSpec {
    let input: CreatePostInput
    let authToken: String?
    let includeDraft: Bool

    /// Notice: Post<BlogPost> means "POST request that returns a BlogPost"
    ///
    /// This example demonstrates if-else usage in modifiers:
    /// - Conditionally adding headers based on optional values
    /// - Conditionally adding query items based on boolean flags
    var request: Post<BlogPost> {
        Post("posts")
            .body(encoder: JSONEncoder()) {
                input
            }
            .headers {
                ContentType("application/json")
                Accept("application/json")

                // Conditional header: only add Authorization if token is provided
                if let token = authToken {
                    Authorization("Bearer \(token)")
                }
            }
            .queryItems {
                // Conditional query item: only add draft parameter if enabled
                if includeDraft {
                    Item("draft", value: "true")
                }
            }
            .timeout(10)
    }
}
