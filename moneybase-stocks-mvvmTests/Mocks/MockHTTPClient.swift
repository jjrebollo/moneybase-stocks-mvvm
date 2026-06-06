//
//  MockHTTPClient.swift
//  moneybase-stocks-mvvmTests
//
//  Created by Juan Jose Rebollo on 06/06/2026.
//

import Foundation
@testable import moneybase_stocks_mvvm

/// Configurable `HTTPClient` spy that returns a stubbed result and records
/// every request it is asked to send.
nonisolated final class MockHTTPClient: HTTPClient, @unchecked Sendable {
    enum Stub {
        case success(Data, HTTPURLResponse)
        case failure(any Error)
    }

    private let stub: Stub
    private(set) var sentRequests: [URLRequest] = []

    init(stub: Stub) {
        self.stub = stub
    }

    convenience init(
        json: String,
        statusCode: Int = 200,
        url: URL = URL(string: "https://example.com")!
    ) {
        let response = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        self.init(stub: .success(Data(json.utf8), response))
    }

    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        sentRequests.append(request)

        switch stub {
        case let .success(data, response):
            return (data, response)
        case let .failure(error):
            throw error
        }
    }
}
