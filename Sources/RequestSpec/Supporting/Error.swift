//
//  Error.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 8.10.2025.
//

/// Errors that can occur when working with RequestSpec.
///
/// `RequestSpecError` represents the various error conditions that can occur when building
/// or executing requests in the RequestSpec library.
public enum RequestSpecError: Error, Sendable {
    /// The URL could not be constructed from the provided components.
    ///
    /// This error occurs when the base URL and path components cannot be combined to form
    /// a valid URL, typically due to invalid characters or malformed URL components.
    case invalidURL

    /// The response body could not be decoded into the expected type.
    ///
    /// This error occurs when the server returns data that cannot be decoded into the
    /// specified `ResponseBody` type. The error includes both the raw response data
    /// and the underlying decoding error for debugging purposes.
    ///
    /// - Parameters:
    ///   - response: An ``HTTPResponse`` containing the raw `Data` that failed to decode
    ///   - underlyingError: The original error thrown by the decoder
    case decodingFailed(response: HTTPResponse<Data>, underlyingError: any Error)
}
