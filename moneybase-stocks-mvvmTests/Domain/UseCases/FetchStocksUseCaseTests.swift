//
//  FetchStocksUseCaseTests.swift
//  moneybase-stocks-mvvmTests
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Testing
@testable import moneybase_stocks_mvvm

struct FetchStocksUseCaseTests {
    @Test("execute defaults to page 1")
    func executeDefaultsToPageOne() async throws {
        let pageOne = [TestDataFactory.quote(symbol: "AAPL")]
        let repository = MockStocksRepository(stocksByPage: [1: pageOne])
        let sut = FetchStocksUseCase(repository: repository)

        let result = try await sut.execute(nil)

        #expect(result == pageOne)
        let requestedPages = await repository.requestedPages
        #expect(requestedPages == [1])
    }

    @Test("execute uses provided page")
    func executeUsesProvidedPage() async throws {
        let pageTwo = [TestDataFactory.quote(symbol: "MSFT")]
        let repository = MockStocksRepository(stocksByPage: [2: pageTwo])
        let sut = FetchStocksUseCase(repository: repository)

        let result = try await sut.execute(2)

        #expect(result == pageTwo)
        let requestedPages = await repository.requestedPages
        #expect(requestedPages == [2])
    }
}
