//
//  TestDataFactory.swift
//  moneybase-stocks-mvvmTests
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Foundation
@testable import moneybase_stocks_mvvm

enum TestDataFactory {
    static func quote(symbol: String, name: String? = nil) -> StockQuote {
        StockQuote(
            symbol: symbol,
            name: name ?? symbol,
            lastPrice: 100,
            netChange: 1,
            percentChange: 1,
            marketCap: 1_000_000
        )
    }

    static func profile(symbol: String) -> StockProfile {
        StockProfile(
            symbol: symbol,
            companyName: "Company \(symbol)",
            sector: "Technology",
            industry: "Software",
            website: "https://example.com",
            summary: "Summary",
            fullTimeEmployees: 1000
        )
    }
}
