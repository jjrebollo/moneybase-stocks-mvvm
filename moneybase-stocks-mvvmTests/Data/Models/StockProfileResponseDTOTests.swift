//
//  StockProfileResponseDTOTests.swift
//  moneybase-stocks-mvvmTests
//
//  Created by Juan Jose Rebollo on 06/06/2026.
//

import Foundation
import Testing
@testable import moneybase_stocks_mvvm

struct StockProfileResponseDTOTests {
    @Test("decodes nested body and maps to the domain model")
    func mapsToDomainModel() throws {
        let json = """
        {
            "meta": { "symbol": "AAPL" },
            "body": {
                "website": "https://apple.com",
                "industry": "Consumer Electronics",
                "sector": "Technology",
                "longBusinessSummary": "Apple designs and sells consumer electronics.",
                "fullTimeEmployees": 161000
            }
        }
        """

        let response = try JSONDecoder().decode(StockProfileResponseDTO.self, from: Data(json.utf8))
        let profile = response.parseToDomainModel()

        #expect(profile.symbol == "AAPL")
        #expect(profile.sector == "Technology")
        #expect(profile.industry == "Consumer Electronics")
        #expect(profile.website == "https://apple.com")
        #expect(profile.summary == "Apple designs and sells consumer electronics.")
        #expect(profile.fullTimeEmployees == 161000)
    }

    @Test("throws when a required field is missing")
    func throwsOnMissingField() {
        let json = """
        {
            "meta": { "symbol": "AAPL" },
            "body": {
                "website": "https://apple.com",
                "industry": "Consumer Electronics",
                "sector": "Technology",
                "longBusinessSummary": "Summary"
            }
        }
        """

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(StockProfileResponseDTO.self, from: Data(json.utf8))
        }
    }
}
