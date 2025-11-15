/*
 ╔═══════════════════════════════════════════════════════════════════════════════════╗
 ║                                                                                   ║
 ║                         RequestSpec Example Application                           ║
 ║                                                                                   ║
 ╚═══════════════════════════════════════════════════════════════════════════════════╝

 Welcome! 👋

 This example demonstrates how to build a complete, type-safe REST API client using
 RequestSpec. We're using JSONPlaceholder (a free fake REST API) to show real-world
 patterns you can apply to your own projects.

 ┌─────────────────────────────────────────────────────────────────────────────────┐
 │ What You'll Learn:                                                              │
 ├─────────────────────────────────────────────────────────────────────────────────┤
 │ • How to define type-safe API requests using RequestSpec                       │
 │ • GET, POST, PUT, PATCH, DELETE operations                                     │
 │ • Working with path parameters (/posts/1)                                      │
 │ • Working with query parameters (?userId=1)                                    │
 │ • Conditional modifiers (if/else in headers & query items) 🌟                  │
 │ • Nested routes (/posts/1/comments)                                            │
 │ • Request/response models with proper Codable mapping                          │
 │ • Protocol-based service architecture for testability                          │
 └─────────────────────────────────────────────────────────────────────────────────┘

 ┌─────────────────────────────────────────────────────────────────────────────────┐
 │ 📚 Table of Contents                                                            │
 ├─────────────────────────────────────────────────────────────────────────────────┤
 │                                                                                 │
 │ 📱 EXAMPLE DEMONSTRATIONS                                                       │
 │    • Posts, Comments, Albums           → Lines ~120-275                        │
 │    • Photos, Todos, Users              → Lines ~275-395                        │
 │                                                                                 │
 │ 🏗️  ARCHITECTURE                                                                │
 │    • Service Protocol & Implementation → Lines ~395-590                        │
 │    • Response & Input Models           → Lines ~590-810                        │
 │                                                                                 │
 │ 🌐 REQUEST DEFINITIONS                                                          │
 │    • RequestSpec implementations       → Lines ~810-1265                       │
 │    • Abstract template included        → Lines ~835-873                        │
 │    • Conditional request definitions   → Lines ~1265-1300                       │
 │                                                                                 │
 └─────────────────────────────────────────────────────────────────────────────────┘

 💡 Pro Tips:
    • All responses are real data from jsonplaceholder.typicode.com
    • Check out the request definitions at the bottom to see RequestSpec in action

 */

import RequestSpec

// MARK: - Main Entry Point

/// The main entry point for our example app
/// Just creates the service and runs all the demonstrations
@main
struct RequestSpecExample {
    static func main() async throws {
        let service = JSONPlaceholderService()
        let app = JSONPlaceholderApp(service: service)
        try await app.run()
    }
}

// MARK: - App

/// The main app that demonstrates all JSONPlaceholder API operations
/// This is where we call all our example functions in a nice organized way
@MainActor
struct JSONPlaceholderApp {
    let service: JSONPlaceholderServiceProtocol

    /// Runs all demonstration functions in sequence
    /// Feel free to comment out any section you don't want to run!
    func run() async throws {
        try await demonstratePosts()
        try await demonstrateComments()
        try await demonstrateAlbums()
        try await demonstratePhotos()
        try await demonstrateTodos()
        try await demonstrateUsers()

        // Easily try it out yourself!
        // let response = try await service.send(GetPostsRequest())

        print("═══════════════════════════════════════")
        print("✨ All operations completed successfully!")
        print("═══════════════════════════════════════")
    }

    // MARK: - Posts Examples

    /// Demonstrates all post-related operations
    /// Shows: GET all, GET single, GET nested, POST, PUT, DELETE
    func demonstratePosts() async throws {
        print("═══════════════════════════════════════")
        print("📝 POSTS")
        print("═══════════════════════════════════════\n")

        try await fetchAllPosts()
        try await fetchSinglePost()
        try await fetchPostComments()
        try await createNewPost()
        try await updateExistingPost()
        try await deleteExistingPost()

        print()
    }

    /// Example: GET /posts
    /// Fetches all posts from the API (returns 100 posts)
    func fetchAllPosts() async throws {
        let posts = try await service.getPosts()
        print("✓ Fetched \(posts.count) posts")
    }

    /// Example: GET /posts/1
    /// Fetches a single post by ID using path parameter
    func fetchSinglePost() async throws {
        let post = try await service.getPost(id: 1)
        print("✓ Fetched post: \(post.title)")
    }

    /// Example: GET /posts/1/comments
    /// Demonstrates nested routes - getting comments for a specific post
    func fetchPostComments() async throws {
        let comments = try await service.getPostComments(postID: 1)
        print("✓ Post has \(comments.count) comments")
    }

    /// Example: POST /posts
    /// Creates a new post by sending JSON in the request body
    /// Note: JSONPlaceholder simulates this - it won't actually save
    func createNewPost() async throws {
        let createdPost = try await service.createPost(
            CreatePostInput(
                title: "New Post",
                body: "Content here",
                userID: 1
            ))
        print("✓ Created post with ID: \(createdPost.id)")
    }

    /// Example: PUT /posts/1
    /// Full update of a post - replaces all fields
    /// PUT vs PATCH: PUT replaces everything, PATCH updates specific fields
    func updateExistingPost() async throws {
        let updatedPost = try await service.updatePost(
            id: 1,
            UpdatePostInput(
                title: "Updated Title",
                body: "Updated content",
                userID: 1
            ))
        print("✓ Updated post: \(updatedPost.title)")
    }

    /// Example: DELETE /posts/1
    /// Deletes a post (simulated by JSONPlaceholder)
    func deleteExistingPost() async throws {
        try await service.deletePost(id: 1)
        print("✓ Deleted post")
    }

    // MARK: - Comments Examples

    /// Demonstrates comment-related operations
    /// Shows: GET all, GET single, POST
    func demonstrateComments() async throws {
        print("═══════════════════════════════════════")
        print("💬 COMMENTS")
        print("═══════════════════════════════════════\n")

        try await fetchAllComments()
        try await fetchSingleComment()
        try await createNewComment()

        print()
    }

    /// Example: GET /comments
    /// Fetches all comments from all posts (returns 500 comments)
    func fetchAllComments() async throws {
        let comments = try await service.getComments()
        print("✓ Fetched \(comments.count) comments")
    }

    /// Example: GET /comments/1
    /// Fetches a single comment by ID
    func fetchSingleComment() async throws {
        let comment = try await service.getComment(id: 1)
        print("✓ Fetched comment by: \(comment.email)")
    }

    /// Example: POST /comments
    /// Creates a new comment with JSON body
    func createNewComment() async throws {
        let createdComment = try await service.createComment(
            CreateCommentInput(
                postID: 1,
                name: "John Doe",
                email: "john@example.com",
                body: "Great post!"
            ))
        print("✓ Created comment with ID: \(createdComment.id)")
    }

    // MARK: - Albums Examples

    /// Demonstrates album-related operations
    /// Shows: GET all, GET single, GET nested (photos)
    func demonstrateAlbums() async throws {
        print("═══════════════════════════════════════")
        print("📚 ALBUMS")
        print("═══════════════════════════════════════\n")

        try await fetchAllAlbums()
        try await fetchSingleAlbum()
        try await fetchAlbumPhotos()

        print()
    }

    /// Example: GET /albums
    /// Fetches all albums (returns 100 albums)
    func fetchAllAlbums() async throws {
        let albums = try await service.getAlbums()
        print("✓ Fetched \(albums.count) albums")
    }

    /// Example: GET /albums/1
    /// Fetches a single album by ID
    func fetchSingleAlbum() async throws {
        let album = try await service.getAlbum(id: 1)
        print("✓ Fetched album: \(album.title)")
    }

    /// Example: GET /albums/1/photos
    /// Another nested route example - getting all photos in an album
    func fetchAlbumPhotos() async throws {
        let photos = try await service.getAlbumPhotos(albumID: 1)
        print("✓ Album has \(photos.count) photos")
    }

    // MARK: - Photos Examples

    /// Demonstrates photo-related operations
    /// Shows: GET all, GET single
    func demonstratePhotos() async throws {
        print("═══════════════════════════════════════")
        print("📷 PHOTOS")
        print("═══════════════════════════════════════\n")

        try await fetchAllPhotos()
        try await fetchSinglePhoto()

        print()
    }

    /// Example: GET /photos
    /// Fetches all photos from all albums (returns 5000 photos!)
    func fetchAllPhotos() async throws {
        let photos = try await service.getPhotos()
        print("✓ Fetched \(photos.count) photos")
    }

    /// Example: GET /photos/1
    /// Fetches a single photo by ID with thumbnail and full-size URLs
    func fetchSinglePhoto() async throws {
        let photo = try await service.getPhoto(id: 1)
        print("✓ Fetched photo: \(photo.title)")
    }

    // MARK: - Todos Examples

    /// Demonstrates todo-related operations
    /// Shows: GET all, GET single, POST
    func demonstrateTodos() async throws {
        print("═══════════════════════════════════════")
        print("✅ TODOS")
        print("═══════════════════════════════════════\n")

        try await fetchAllTodos()
        try await fetchSingleTodo()
        try await createNewTodo()

        print()
    }

    /// Example: GET /todos
    /// Fetches all todos (returns 200 todos)
    func fetchAllTodos() async throws {
        let todos = try await service.getTodos()
        print("✓ Fetched \(todos.count) todos")
    }

    /// Example: GET /todos/1
    /// Fetches a single todo with completion status
    func fetchSingleTodo() async throws {
        let todo = try await service.getTodo(id: 1)
        print("✓ Fetched todo: \(todo.title) (completed: \(todo.completed))")
    }

    /// Example: POST /todos
    /// Creates a new todo item
    func createNewTodo() async throws {
        let createdTodo = try await service.createTodo(
            CreateTodoInput(
                title: "Learn RequestSpec",
                completed: false,
                userID: 1
            ))
        print("✓ Created todo with ID: \(createdTodo.id)")
    }

    // MARK: - Users Examples

    /// Demonstrates user-related operations and filtering
    /// Shows: GET all, GET single, GET with query parameters
    func demonstrateUsers() async throws {
        print("═══════════════════════════════════════")
        print("👤 USERS")
        print("═══════════════════════════════════════\n")

        try await fetchAllUsers()
        try await fetchSingleUser()
        try await fetchUserRelatedResources()

        print()
    }

    /// Example: GET /users
    /// Fetches all users (returns 10 users)
    func fetchAllUsers() async throws {
        let users = try await service.getUsers()
        print("✓ Fetched \(users.count) users")
    }

    /// Example: GET /users/1
    /// Fetches a single user with nested address and company data
    /// Shows how to handle complex nested JSON structures
    func fetchSingleUser() async throws {
        let user = try await service.getUser(id: 1)
        print("✓ Fetched user: \(user.name) (\(user.email))")
        print("  Company: \(user.company.name)")
        print("  Address: \(user.address.city)")
    }

    /// Examples: GET /posts?userId=1, GET /albums?userId=1, GET /todos?userId=1
    /// Demonstrates query parameter filtering to get related resources
    /// This is super useful for "get all X for user Y" scenarios
    func fetchUserRelatedResources() async throws {
        let userPosts = try await service.getUserPosts(userID: 1)
        print("✓ User has \(userPosts.count) posts")

        let userAlbums = try await service.getUserAlbums(userID: 1)
        print("✓ User has \(userAlbums.count) albums")

        let userTodos = try await service.getUserTodos(userID: 1)
        print("✓ User has \(userTodos.count) todos")
    }
}

// MARK: - Service Protocol & Implementation

/// Protocol defining all JSONPlaceholder API operations
///
/// Why use a protocol? Two big reasons:
/// 1. Makes testing super easy - just mock this protocol
/// 2. Separates the "what" (interface) from the "how" (implementation)
///
/// By conforming to NetworkService, we get the send() method that handles
/// all the networking heavy lifting for us.
protocol JSONPlaceholderServiceProtocol: NetworkService, Sendable {
    // MARK: Posts
    func getPosts() async throws -> [BlogPost]
    func getPost(id: Int) async throws -> BlogPost
    func getPostComments(postID: Int) async throws -> [Comment]
    func createPost(_ input: CreatePostInput) async throws -> BlogPost
    func updatePost(id: Int, _ input: UpdatePostInput) async throws -> BlogPost
    func patchPost(id: Int, _ input: PatchPostInput) async throws -> BlogPost
    func deletePost(id: Int) async throws

    // MARK: Comments
    func getComments() async throws -> [Comment]
    func getComment(id: Int) async throws -> Comment
    func createComment(_ input: CreateCommentInput) async throws -> Comment

    // MARK: Albums
    func getAlbums() async throws -> [Album]
    func getAlbum(id: Int) async throws -> Album
    func getAlbumPhotos(albumID: Int) async throws -> [Photo]

    // MARK: Photos
    func getPhotos() async throws -> [Photo]
    func getPhoto(id: Int) async throws -> Photo

    // MARK: Todos
    func getTodos() async throws -> [Todo]
    func getTodo(id: Int) async throws -> Todo
    func createTodo(_ input: CreateTodoInput) async throws -> Todo

    // MARK: Users
    func getUsers() async throws -> [User]
    func getUser(id: Int) async throws -> User
    func getUserPosts(userID: Int) async throws -> [BlogPost]
    func getUserAlbums(userID: Int) async throws -> [Album]
    func getUserTodos(userID: Int) async throws -> [Todo]
}

/// The actual implementation of our API client
///
/// This service handles all communication with JSONPlaceholder.
/// Each method:
/// 1. Creates a request using our RequestSpec definitions (see bottom of file)
/// 2. Sends it using the send() method from NetworkService
/// 3. Extracts and returns the response body
///
/// The baseURL and decoder are required by NetworkService protocol.
final class JSONPlaceholderService: JSONPlaceholderServiceProtocol {
    /// Base URL for all API requests
    let baseURL: URL = URL(string: "https://jsonplaceholder.typicode.com")!

    /// JSON decoder configuration
    /// We're using default keys here, but you could customize this
    /// (e.g., convert snake_case to camelCase if your API uses that)
    let decoder: Decoder & Sendable = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }()

    // MARK: - Posts

    func getPosts() async throws -> [BlogPost] {
        let response = try await send(GetPostsRequest())
        return response.body
    }

    func getPost(id: Int) async throws -> BlogPost {
        let response = try await send(GetPostRequest(id: id))
        return response.body
    }

    func getPostComments(postID: Int) async throws -> [Comment] {
        let response = try await send(GetPostCommentsRequest(postID: postID))
        return response.body
    }

    func createPost(_ input: CreatePostInput) async throws -> BlogPost {
        let response = try await send(CreatePostRequest(input: input))
        return response.body
    }

    func updatePost(id: Int, _ input: UpdatePostInput) async throws -> BlogPost {
        let response = try await send(UpdatePostRequest(id: id, input: input))
        return response.body
    }

    func patchPost(id: Int, _ input: PatchPostInput) async throws -> BlogPost {
        let response = try await send(PatchPostRequest(id: id, input: input))
        return response.body
    }

    func deletePost(id: Int) async throws {
        _ = try await send(DeletePostRequest(id: id))
    }

    // MARK: - Comments

    func getComments() async throws -> [Comment] {
        let response = try await send(GetCommentsRequest())
        return response.body
    }

    func getComment(id: Int) async throws -> Comment {
        let response = try await send(GetCommentRequest(id: id))
        return response.body
    }

    func createComment(_ input: CreateCommentInput) async throws -> Comment {
        let response = try await send(
            CreateCommentRequest(
                input: input,
                authToken: "sample-token-123",  // Example: Could be nil for unauthenticated requests
                includeMetadata: true,  // Example: Request metadata in response
                isPriority: false  // Example: Normal priority comment
            ))
        return response.body
    }

    // MARK: - Albums

    func getAlbums() async throws -> [Album] {
        let response = try await send(GetAlbumsRequest())
        return response.body
    }

    func getAlbum(id: Int) async throws -> Album {
        let response = try await send(GetAlbumRequest(id: id))
        return response.body
    }

    func getAlbumPhotos(albumID: Int) async throws -> [Photo] {
        let response = try await send(GetAlbumPhotosRequest(albumID: albumID))
        return response.body
    }

    // MARK: - Photos

    func getPhotos() async throws -> [Photo] {
        let response = try await send(GetPhotosRequest())
        return response.body
    }

    func getPhoto(id: Int) async throws -> Photo {
        let response = try await send(GetPhotoRequest(id: id))
        return response.body
    }

    // MARK: - Todos

    func getTodos() async throws -> [Todo] {
        let response = try await send(GetTodosRequest())
        return response.body
    }

    func getTodo(id: Int) async throws -> Todo {
        let response = try await send(GetTodoRequest(id: id))
        return response.body
    }

    func createTodo(_ input: CreateTodoInput) async throws -> Todo {
        let response = try await send(CreateTodoRequest(input: input))
        return response.body
    }

    // MARK: - Users

    func getUsers() async throws -> [User] {
        let response = try await send(GetUsersRequest())
        return response.body
    }

    func getUser(id: Int) async throws -> User {
        let response = try await send(GetUserRequest(id: id))
        return response.body
    }

    func getUserPosts(userID: Int) async throws -> [BlogPost] {
        let response = try await send(GetUserPostsRequest(userID: userID))
        return response.body
    }

    func getUserAlbums(userID: Int) async throws -> [Album] {
        let response = try await send(GetUserAlbumsRequest(userID: userID))
        return response.body
    }

    func getUserTodos(userID: Int) async throws -> [Todo] {
        let response = try await send(GetUserTodosRequest(userID: userID))
        return response.body
    }
}

// MARK: - Models

/*
 ═══════════════════════════════════════════════════════════════════
 Response Models
 ═══════════════════════════════════════════════════════════════════

 These structs represent the JSON data we get back from the API.

 Key things to notice:
 • All conform to Codable for automatic JSON parsing
 • We use Swift naming (userID) but map to JSON naming (userId) via CodingKeys
 • This gives us the best of both worlds: Swift conventions in code,
   proper JSON in network requests
 */

/// Represents a blog post from the API
struct BlogPost: Codable {
    let id: Int
    let userID: Int  // Who wrote this post
    let title: String
    let body: String

    // Maps Swift property names to JSON keys
    // userID in Swift → userId in JSON
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case title
        case body
    }
}

/// Represents a comment on a post
struct Comment: Codable {
    let id: Int
    let postID: Int  // Which post this comment belongs to
    let name: String  // Commenter's name
    let email: String  // Commenter's email
    let body: String  // Comment content

    enum CodingKeys: String, CodingKey {
        case id
        case postID = "postId"
        case name
        case email
        case body
    }
}

/// Represents a photo album
struct Album: Codable {
    let id: Int
    let userID: Int  // Who owns this album
    let title: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case title
    }
}

/// Represents a photo in an album
struct Photo: Codable {
    let id: Int
    let albumID: Int  // Which album this photo belongs to
    let title: String
    let url: String  // Full-size photo URL
    let thumbnailUrl: String  // Thumbnail URL

    enum CodingKeys: String, CodingKey {
        case id
        case albumID = "albumId"
        case title
        case url
        case thumbnailUrl
    }
}

/// Represents a todo item
struct Todo: Codable {
    let id: Int
    let userID: Int  // Who owns this todo
    let title: String
    let completed: Bool  // Is it done?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case title
        case completed
    }
}

/// Represents a user with nested address and company data
struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company

    /// Nested address structure
    struct Address: Codable {
        let street: String
        let suite: String
        let city: String
        let zipcode: String
        let geo: Geo

        /// Geographic coordinates
        struct Geo: Codable {
            let lat: String
            let lng: String
        }
    }

    /// Nested company structure
    struct Company: Codable {
        let name: String
        let catchPhrase: String
        let bs: String  // Business strategy
    }
}

// MARK: - Input Models

/*
 ═══════════════════════════════════════════════════════════════════
 Input Models
 ═══════════════════════════════════════════════════════════════════

 These structs represent the data we SEND to the API in POST/PUT/PATCH requests.
 They're separate from response models because:
 • Input often has fewer fields (e.g., no ID when creating)
 • Some fields might be optional for PATCH but required for POST
 • Keeps the API surface clear about what you can/can't send
 */

/// Data needed to create a new post
struct CreatePostInput: Codable {
    let title: String
    let body: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case title
        case body
        case userID = "userId"
    }
}

/// Data for completely updating a post (PUT)
/// PUT replaces the entire resource, so all fields are required
struct UpdatePostInput: Codable {
    let title: String
    let body: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case title
        case body
        case userID = "userId"
    }
}

/// Data for partially updating a post (PATCH)
/// PATCH only updates the fields you provide, so they're optional
struct PatchPostInput: Codable {
    let title: String?
    // Could add more optional fields here:
    // let body: String?
    // let userID: Int?
}

/// Data needed to create a new comment
struct CreateCommentInput: Codable {
    let postID: Int  // Which post to comment on
    let name: String  // Commenter's name
    let email: String  // Commenter's email
    let body: String  // Comment text

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case name
        case email
        case body
    }
}

/// Data needed to create a new todo
struct CreateTodoInput: Codable {
    let title: String
    let completed: Bool  // Start as done or not done?
    let userID: Int  // Who owns this todo

    enum CodingKeys: String, CodingKey {
        case title
        case completed
        case userID = "userId"
    }
}

// MARK: - Request Definitions

/*
 ═══════════════════════════════════════════════════════════════════
 RequestSpec Definitions
 ═══════════════════════════════════════════════════════════════════

 This is where the magic happens! ✨

 Each struct conforms to RequestSpec and defines ONE specific API request.

 Anatomy of a request spec:
 1. Struct holds any parameters (ID, filters, input data, etc.)
 2. The `request` property defines:
    • HTTP method (Get, Post, Put, Patch, Delete)
    • Response type (what we expect back)
    • URL path segments
    • Query parameters (optional)
    • Request body (optional, for POST/PUT/PATCH)
    • Headers (optional)
    • Timeout (optional)

 RequestSpec then turns this into actual HTTP requests automatically!

 ┌─────────────────────────────────────────────────────────────────┐
 │ Abstract Usage Template                                         │
 └─────────────────────────────────────────────────────────────────┘

 Here's the general pattern for creating any request:

 struct YourRequest: RequestSpec {
     -- 1. Add any parameters your request needs --
     let id: Int?
     let queryParam: String?
     let inputData: SomeInputModel?

     -- 2. Define the request body --
     var request: HTTPMethod<ResponseType> {
         HTTPMethod("path", "segments")  // e.g., Get, Post, Put, Patch, Delete
             .queryItems {  // Optional: for ?key=value in URL
                 Item("key", value: "value")
             }
             .body {  // Optional: for POST/PUT/PATCH
                 inputData
             }
             .headers {  // Optional: customize headers
                 Accept("application/json")
                 ContentType("application/json")
                 UserAgent("YourApp/1.0")
                 Authorization("Bearer token")
             }
             .timeout(10)  // Optional: custom timeout
     }
 }

 Available HTTP Methods:
 • Get<T>     → GET request, returns T
 • Post<T>    → POST request, returns T
 • Put<T>     → PUT request, returns T
 • Patch<T>   → PATCH request, returns T
 • Delete<T>  → DELETE request, returns T

 */

// MARK: - Post Requests

/// GET /posts - Fetches all posts
///
/// Example URL: https://jsonplaceholder.typicode.com/posts
///
/// This is the simplest type of request: just a GET with no parameters.
/// Notice how we specify Get<[BlogPost]> - that tells RequestSpec:
/// • Use HTTP GET method
/// • Expect an array of BlogPost objects back
struct GetPostsRequest: RequestSpec {
    var request: Get<[BlogPost]> {
        Get("posts")  // URL path segment
            .headers {
                Accept("application/json")  // Tell server we want JSON
                UserAgent("RequestSpec/1.0")  // Identify our client
            }
            .timeout(10)  // Wait max 10 seconds
    }
}

/// GET /posts/:id - Fetches a single post by ID
///
/// Example URL: https://jsonplaceholder.typicode.com/posts/1
///
/// Shows how to use PATH PARAMETERS (the :id part of the URL).
/// We store the id as a property and interpolate it into the path.
struct GetPostRequest: RequestSpec {
    let id: Int  // Store the parameter

    var request: Get<BlogPost> {
        Get("posts", "\(id)")  // Build path: posts/1, posts/2, etc.
            .headers {
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

/// GET /posts/:id/comments - Fetches comments for a specific post
///
/// Example URL: https://jsonplaceholder.typicode.com/posts/1/comments
///
/// Shows NESTED ROUTES - when one resource belongs to another.
/// This pattern is super common in REST APIs!
struct GetPostCommentsRequest: RequestSpec {
    let postID: Int

    var request: Get<[Comment]> {
        // Multiple path segments create nested routes
        Get("posts", "\(postID)", "comments")
            .headers {
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

/// GET /posts?userId=1 - Fetches posts filtered by user
///
/// Example URL: https://jsonplaceholder.typicode.com/posts?userId=1
///
/// Shows QUERY PARAMETERS - filtering results using ?key=value in the URL.
/// Query params are perfect for filtering, sorting, pagination, etc.
struct GetUserPostsRequest: RequestSpec {
    let userID: Int

    var request: Get<[BlogPost]> {
        Get("posts")
            .queryItems {
                // This becomes ?userId=1 in the URL
                Item("userId", value: "\(userID)")
                // You can add more:
                // Item("sort", value: "desc")
                // Item("limit", value: "10")
            }
            .headers {
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

/// POST /posts - Creates a new post
///
/// Example URL: https://jsonplaceholder.typicode.com/posts
///
/// Shows how to SEND DATA TO THE SERVER using a POST request.
/// The input data gets automatically converted to JSON and sent in the request body.
///
/// Notice: Post<BlogPost> means "POST request that returns a BlogPost"
struct CreatePostRequest: RequestSpec {
    let input: CreatePostInput  // Data to send

    var request: Post<BlogPost> {
        Post("posts")
            .body {
                input  // This gets JSON-encoded automatically!
            }
            .headers {
                ContentType("application/json")  // Tell server we're sending JSON
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

/// PUT /posts/:id - Fully updates a post
///
/// PUT replaces the entire resource with new data.
/// All fields must be provided (hence UpdatePostInput has all fields).
struct UpdatePostRequest: RequestSpec {
    let id: Int
    let input: UpdatePostInput

    var request: Put<BlogPost> {
        Put("posts", "\(id)")
            .body {
                input
            }
            .headers {
                ContentType("application/json")
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

/// PATCH /posts/:id - Partially updates a post
///
/// PATCH only updates the fields you send.
/// Other fields remain unchanged (hence PatchPostInput has optional fields).
/// Use PATCH when you want to update just one or two fields without touching the rest.
struct PatchPostRequest: RequestSpec {
    let id: Int
    let input: PatchPostInput

    var request: Patch<BlogPost> {
        Patch("posts", "\(id)")
            .body {
                input
            }
            .headers {
                ContentType("application/json")
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

/// DELETE /posts/:id - Deletes a post
///
/// DELETE requests typically don't return useful data, so we use Delete<Data>
/// which just gives us the raw response data (usually empty).
struct DeletePostRequest: RequestSpec {
    let id: Int

    var request: Delete<Data> {
        Delete("posts", "\(id)")
            .headers {
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

// MARK: - Comment Requests

/*
 ═══════════════════════════════════════════════════════════════════
 🌟 FEATURED: Conditional Modifiers Example
 ═══════════════════════════════════════════════════════════════════

 The CreateCommentRequest below demonstrates how to use if/else statements
 in modifier builders (.headers, .queryItems) to conditionally include
 headers and query parameters based on runtime values.

 This is one of RequestSpec's most powerful features for building flexible,
 reusable request definitions!

 ───────────────────────────────────────────────────────────────────

 The remaining request definitions follow the same patterns shown above:
 • Path parameters (id in URL)
 • Query parameters (?key=value)
 • Request bodies for POST/PUT/PATCH
 • Proper headers and timeouts

 Feel free to explore them - they're great references when building your own API client!
 */

struct GetCommentsRequest: RequestSpec {
    var request: Get<[Comment]> {
        Get("comments")
            .headers {
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

struct GetCommentRequest: RequestSpec {
    let id: Int

    var request: Get<Comment> {
        Get("comments", "\(id)")
            .headers {
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

/// POST /comments - Creates a new comment
///
/// This example demonstrates **conditional modifiers** - how to use if/else statements
/// within modifier builders like .headers { } and .queryItems { }.
///
/// ## Conditional Modifiers Pattern
///
/// You can use Swift's control flow (if, if-let, switch, loops) inside builder closures
/// to conditionally add headers, query items, or body parameters based on runtime values:
///
/// This makes your requests flexible and type-safe without needing multiple request definitions.
struct CreateCommentRequest: RequestSpec {
    let input: CreateCommentInput
    let authToken: String?  // Optional authentication token
    let includeMetadata: Bool  // Whether to include metadata in response
    let isPriority: Bool  // Whether this is a priority comment

    var request: Post<Comment> {
        Post("comments")
            .body {
                input
            }
            .headers {
                ContentType("application/json")
                Accept("application/json")
                UserAgent("RequestSpec/1.0")

                // Conditionally add Authorization header if token is provided
                if let token = authToken {
                    Authorization("Bearer \(token)")
                }
            }
            .queryItems {
                // Conditionally add metadata query parameter
                if includeMetadata {
                    Item("include", value: "metadata")
                }

                // Use if-else to set priority level
                if isPriority {
                    Item("priority", value: "high")
                } else {
                    Item("priority", value: "normal")
                }
            }
            .timeout(10)
    }
}

// MARK: - Album Requests

struct GetAlbumsRequest: RequestSpec {
    var request: Get<[Album]> {
        Get("albums")
            .headers {
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

struct GetAlbumRequest: RequestSpec {
    let id: Int

    var request: Get<Album> {
        Get("albums", "\(id)")
            .headers {
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

struct GetAlbumPhotosRequest: RequestSpec {
    let albumID: Int

    var request: Get<[Photo]> {
        Get("albums", "\(albumID)", "photos")
            .headers {
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

struct GetUserAlbumsRequest: RequestSpec {
    let userID: Int

    var request: Get<[Album]> {
        Get("albums")
            .queryItems {
                Item("userId", value: "\(userID)")
            }
            .headers {
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

// MARK: - Photo Requests

struct GetPhotosRequest: RequestSpec {
    var request: Get<[Photo]> {
        Get("photos")
            .headers {
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

struct GetPhotoRequest: RequestSpec {
    let id: Int

    var request: Get<Photo> {
        Get("photos", "\(id)")
            .headers {
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

// MARK: - Todo Requests

struct GetTodosRequest: RequestSpec {
    var request: Get<[Todo]> {
        Get("todos")
            .headers {
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

struct GetTodoRequest: RequestSpec {
    let id: Int

    var request: Get<Todo> {
        Get("todos", "\(id)")
            .headers {
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

struct CreateTodoRequest: RequestSpec {
    let input: CreateTodoInput

    var request: Post<Todo> {
        Post("todos")
            .body {
                input
            }
            .headers {
                ContentType("application/json")
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

struct GetUserTodosRequest: RequestSpec {
    let userID: Int

    var request: Get<[Todo]> {
        Get("todos")
            .queryItems {
                Item("userId", value: "\(userID)")
            }
            .headers {
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

// MARK: - User Requests

struct GetUsersRequest: RequestSpec {
    var request: Get<[User]> {
        Get("users")
            .headers {
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}

struct GetUserRequest: RequestSpec {
    let id: Int

    var request: Get<User> {
        Get("users", "\(id)")
            .headers {
                Accept("application/json")
                UserAgent("RequestSpec/1.0")
            }
            .timeout(10)
    }
}
