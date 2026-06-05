//
//  YahooFinanceEndpoint.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Foundation

enum YahooFinanceEndpoint: ApiBuilder {
    case stocksList(configuration: RapidAPIConfiguration, page: Int, type: String)
    case stockProfile(configuration: RapidAPIConfiguration, ticker: String, module: String)

    var baseProtocol: String {
        configuration.baseProtocol
    }

    var path: String {
        switch self {
        case .stocksList:
            return "/api/v2/markets/tickers"
        case .stockProfile:
            return "/api/v1/markets/stock/modules"
        }
    }

    var baseURL: String {
        configuration.baseURL
    }

    var port: Int? {
        configuration.port
    }

    var httpMethod: HttpMethod {
        .get
    }

    var globalHeaders: [String: String] {
        configuration.globalHeaders
    }

    var additionalHeaders: [String: String] {
        [:]
    }

    var parameters: [String: Any] {
        [:]
    }

    var urlParameters: [String: String] {
        switch self {
        case let .stocksList(_, page, type):
            return ["page": String(page), "type": type]
        case let .stockProfile(_, ticker, module):
            return ["ticker": ticker, "module": module]
        }
    }

    private var configuration: RapidAPIConfiguration {
        switch self {
        case let .stocksList(configuration, _, _):
            return configuration
        case let .stockProfile(configuration, _, _):
            return configuration
        }
    }
}
