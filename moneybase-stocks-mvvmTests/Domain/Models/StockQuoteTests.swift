//
//  StockQuoteTests.swift
//  moneybase-stocks-mvvmTests
//
//  Created by Juan Jose Rebollo on 06/06/2026.
//

import Testing
@testable import moneybase_stocks_mvvm

struct StockQuoteTests {
    @Test("id is derived from the symbol")
    func idMatchesSymbol() {
        let quote = TestDataFactory.quote(symbol: "AAPL")

        #expect(quote.id == "AAPL")
    }

    @Test("isPositiveChange reflects the sign of netChange", arguments: [
        (0.0, true),
        (1.5, true),
        (-1.5, false)
    ])
    func isPositiveChange(netChange: Double, expected: Bool) {
        var quote = TestDataFactory.quote(symbol: "AAPL")
        quote.netChange = netChange

        #expect(quote.isPositiveChange == expected)
    }

    @Test("marketCapText uses trillion, billion and million suffixes", arguments: [
        (2_500_000_000_000.0, "$2.50T"),
        (3_200_000_000.0, "$3.20B"),
        (4_000_000.0, "$4.00M")
    ])
    func marketCapText(marketCap: Double, expected: String) {
        var quote = TestDataFactory.quote(symbol: "AAPL")
        quote.marketCap = marketCap

        #expect(quote.marketCapText == expected)
    }
}
