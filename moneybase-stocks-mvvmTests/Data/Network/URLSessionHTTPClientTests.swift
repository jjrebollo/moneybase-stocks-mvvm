//
//  URLSessionHTTPClientTests.swift
//  moneybase-stocks-mvvmTests
//
//  Created by Juan Jose Rebollo on 06/06/2026.
//

import Foundation
import Testing
@testable import moneybase_stocks_mvvm

@Suite(.serialized)
struct URLSessionHTTPClientTests {
    private func makeSUT() -> URLSessionHTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        return URLSessionHTTPClient(session: URLSession(configuration: configuration))
    }

    private let url = URL(string: "https://example.com/path")!

    @Test("returns data and the HTTP response on success")
    func returnsDataAndResponse() async throws {
        let expectedData = Data("hello".utf8)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        URLProtocolStub.stub = .init(data: expectedData, response: response, error: nil)
        defer { URLProtocolStub.stub = nil }

        let (data, httpResponse) = try await makeSUT().send(URLRequest(url: url))

        #expect(data == expectedData)
        #expect(httpResponse.statusCode == 200)
    }

    @Test("throws invalidResponse for a non-HTTP response")
    func throwsForNonHTTPResponse() async {
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        URLProtocolStub.stub = .init(data: Data(), response: response, error: nil)
        defer { URLProtocolStub.stub = nil }

        await #expect {
            _ = try await makeSUT().send(URLRequest(url: url))
        } throws: { error in
            (error as? NetworkError).map { if case .invalidResponse = $0 { return true } else { return false } } ?? false
        }
    }

    @Test("propagates transport errors")
    func propagatesTransportError() async {
        let expectedError = NSError(domain: "test", code: -1009)
        URLProtocolStub.stub = .init(data: nil, response: nil, error: expectedError)
        defer { URLProtocolStub.stub = nil }

        await #expect(throws: (any Error).self) {
            _ = try await makeSUT().send(URLRequest(url: url))
        }
    }
}

private final class URLProtocolStub: URLProtocol {
    struct Stub {
        let data: Data?
        let response: URLResponse?
        let error: (any Error)?
    }

    nonisolated(unsafe) static var stub: Stub?

    override class func canInit(with request: URLRequest) -> Bool { true }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let error = Self.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        if let response = Self.stub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let data = Self.stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
