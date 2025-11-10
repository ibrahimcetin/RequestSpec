//
//  RequestSpec.swift
//  RequestSpec
//
//  Created by İbrahim Çetin on 7.10.2025.
//

@_exported import Foundation

public protocol NetworkService {
    /// The base URL to use for the network service
    var baseURL: URL { get }

    /// The session to use for the network service
    var session: URLSession { get }

    /// The decoder to use for the network service
    var decoder: Decoder { get }

    /// Send a request and return the response
    func send<R: Request>(_ request: R) async throws -> HTTPResponse<R.ResponseBody>

    /// Send a request spec and return the response
    func send<RS: RequestSpec>(_ requestSpec: RS) async throws -> HTTPResponse<RS.ResponseBody>
}

extension NetworkService {
    public var session: URLSession {
        URLSession.shared
    }

    public var decoder: Decoder {
        JSONDecoder()
    }
}

extension NetworkService {
    func data<R: Request>(for request: R) async throws -> (Data, URLResponse) {
        let urlRequest = try request.urlRequest(baseURL: baseURL)
        return try await session.data(for: urlRequest)
    }

    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        switch type {
        case is String.Type:
            return String(decoding: data, as: UTF8.self) as! T
        case is Data.Type:
            return data as! T
        default:
            return try decoder.decode(type, from: data)
        }
    }

    public func send<R: Request>(_ request: R) async throws -> HTTPResponse<R.ResponseBody> {
        let (data, response) = try await data(for: request)
        let body = try decode(R.ResponseBody.self, from: data)
        return HTTPResponse(body: body, originalResponse: response as! HTTPURLResponse)
    }

    public func send<RS: RequestSpec>(_ requestSpec: RS) async throws -> HTTPResponse<RS.ResponseBody> {
        try await send(requestSpec.body)
    }
}
