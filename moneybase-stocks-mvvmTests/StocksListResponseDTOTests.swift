//
//  StocksListResponseDTOTests.swift
//  moneybase-stocks-mvvmTests
//
//  Created by Juan Jose Rebollo on 06/06/2026.
//

import Foundation
import Testing
@testable import moneybase_stocks_mvvm

struct StocksListResponseDTOTests {
    private func decodeResponse(_ json: String) throws -> StocksListResponseDTO {
        try JSONDecoder().decode(StocksListResponseDTO.self, from: Data(json.utf8))
    }

    @Test("decodes API keys and maps a valid item to the domain model")
    func mapsValidItem() throws {
        let json = """
        {
            "body": [
                {
                    "symbol": "AAPL",
                    "name": "Apple Inc.",
                    "lastsale": "$1,234.56",
                    "netchange": "12.34",
                    "pctchange": "1.50%",
                    "marketCap": "2,000,000,000"
                }
            ]
        }
        """

        let quotes = try decodeResponse(json).parseToDomainModel()

        #expect(quotes.count == 1)
        let quote = try #require(quotes.first)
        #expect(quote.symbol == "AAPL")
        #expect(quote.name == "Apple Inc.")
        #expect(quote.lastPrice == 1234.56)
        #expect(quote.netChange == 12.34)
        #expect(quote.percentChange == 1.5)
        #expect(quote.marketCap == 2_000_000_000)
    }

    @Test("drops items with unparseable numeric fields")
    func dropsInvalidItems() throws {
        let json = """
        {
            "body": [
                {
                    "symbol": "GOOD",
                    "name": "Good Co",
                    "lastsale": "$10.00",
                    "netchange": "1.00",
                    "pctchange": "1.00%",
                    "marketCap": "1,000,000"
                },
                {
                    "symbol": "BAD",
                    "name": "Bad Co",
                    "lastsale": "N/A",
                    "netchange": "1.00",
                    "pctchange": "1.00%",
                    "marketCap": "1,000,000"
                }
            ]
        }
        """

        let quotes = try decodeResponse(json).parseToDomainModel()

        #expect(quotes.map(\.symbol) == ["GOOD"])
    }

    @Test("returns an empty array when body is null")
    func emptyWhenBodyIsNull() throws {
        let quotes = try decodeResponse(#"{ "body": null }"#).parseToDomainModel()

        #expect(quotes.isEmpty)
    }

    @Test("returns an empty array when body key is missing")
    func emptyWhenBodyIsMissing() throws {
        let quotes = try decodeResponse("{}").parseToDomainModel()

        #expect(quotes.isEmpty)
    }
}
