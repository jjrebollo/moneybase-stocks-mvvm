//
//  StockDetailViewModelTests.swift
//  moneybase-stocks-mvvmTests
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Testing
@testable import moneybase_stocks_mvvm

@MainActor
struct StockDetailViewModelTests {
    @Test("loadIfNeeded fetches once")
    func loadIfNeededFetchesOnce() async {
        let profile = TestDataFactory.profile(symbol: "AAPL")
        let useCase = MockFetchStockProfileUseCase(profilesBySymbol: ["AAPL": profile])
        let sut = StockDetailViewModel(symbol: "AAPL", fetchStockProfileUseCase: useCase)

        await sut.loadIfNeeded()
        await sut.loadIfNeeded()

        #expect(sut.profile == profile)
        let requestedSymbols = useCase.requestedSymbols
        #expect(requestedSymbols == ["AAPL"])
    }

    @Test("load updates profile")
    func loadUpdatesProfile() async {
        let profile = TestDataFactory.profile(symbol: "TSLA")
        let useCase = MockFetchStockProfileUseCase(profilesBySymbol: ["TSLA": profile])
        let sut = StockDetailViewModel(symbol: "TSLA", fetchStockProfileUseCase: useCase)

        await sut.load()

        #expect(sut.profile == profile)
    }
}
