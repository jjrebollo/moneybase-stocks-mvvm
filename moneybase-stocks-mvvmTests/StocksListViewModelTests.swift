//
//  StocksListViewModelTests.swift
//  moneybase-stocks-mvvmTests
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Testing
@testable import moneybase_stocks_mvvm

@MainActor
struct StocksListViewModelTests {
    @Test("onAppear loads first page")
    func onAppearLoadsFirstPage() async {
        let pageOne = [TestDataFactory.quote(symbol: "AAPL")]
        let repository = MockStocksRepository(stocksByPage: [1: pageOne])
        let useCase = FetchStocksUseCase(repository: repository)
        let sut = StocksListViewModel(fetchStocksUseCase: useCase, shouldAutoRefresh: false)

        await sut.onAppear()

        #expect(sut.stocks == pageOne)
        let requestedPages = await repository.requestedPages
        #expect(requestedPages == [1])
    }

    @Test("loadNextPageIfNeeded appends results when last item appears")
    func loadNextPageAppendsResults() async {
        let pageOne = [TestDataFactory.quote(symbol: "AAPL")]
        let pageTwo = [TestDataFactory.quote(symbol: "MSFT")]
        let useCase = MockFetchStocksUseCase(stocksByPage: [1: pageOne, 2: pageTwo])
        let sut = StocksListViewModel(fetchStocksUseCase: useCase, shouldAutoRefresh: false)

        await sut.onAppear()
        await sut.loadNextPageIfNeeded(currentItem: pageOne[0])

        #expect(sut.stocks == pageOne + pageTwo)
        let requestedPages = useCase.requestedPages
        #expect(requestedPages == [1, 2])
    }

    @Test("refreshFromCTA toggles scroll trigger and refreshes page one")
    func refreshFromCTATriggersScrollAndReload() async {
        let pageOne = [TestDataFactory.quote(symbol: "AAPL")]
        let pageTwo = [TestDataFactory.quote(symbol: "MSFT")]
        let refreshedPageOne = [TestDataFactory.quote(symbol: "NVDA")]
        let useCase = MockFetchStocksUseCase(stocksByPage: [1: pageOne, 2: pageTwo])
        let sut = StocksListViewModel(fetchStocksUseCase: useCase, shouldAutoRefresh: false)

        await sut.onAppear()
        await sut.loadNextPageIfNeeded(currentItem: pageOne[0])

        useCase.setStocks(refreshedPageOne, forPage: 1)
        let previousTrigger = sut.scrollToTopTrigger

        await sut.refreshFromCTA()

        #expect(sut.stocks == refreshedPageOne)
        #expect(sut.scrollToTopTrigger != previousTrigger)
        let requestedPages = useCase.requestedPages
        #expect(requestedPages == [1, 2, 1])
    }

    @Test("filteredStocks filters by symbol and name")
    func filteredStocksFiltersBySymbolAndName() async {
        let pageOne = [
            TestDataFactory.quote(symbol: "AAPL", name: "Apple"),
            TestDataFactory.quote(symbol: "MSFT", name: "Microsoft")
        ]
        let useCase = MockFetchStocksUseCase(stocksByPage: [1: pageOne])
        let sut = StocksListViewModel(fetchStocksUseCase: useCase, shouldAutoRefresh: false)

        await sut.onAppear()
        sut.searchText = "micro"

        #expect(sut.filteredStocks.map(\.symbol) == ["MSFT"])
    }
}
