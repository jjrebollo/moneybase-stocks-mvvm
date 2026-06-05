//
//  FetchStockProfileUseCaseTests.swift
//  moneybase-stocks-mvvmTests
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Testing
@testable import moneybase_stocks_mvvm

struct FetchStockProfileUseCaseTests {
    @Test("execute requests profile by symbol")
    func executeRequestsProfileBySymbol() async throws {
        let profile = TestDataFactory.profile(symbol: "NVDA")
        let repository = MockStocksRepository(profilesBySymbol: ["NVDA": profile])
        let sut = FetchStockProfileUseCase(repository: repository)

        let result = try await sut.execute("NVDA")

        #expect(result == profile)
        let requestedSymbols = await repository.requestedSymbols
        #expect(requestedSymbols == ["NVDA"])
    }
}
