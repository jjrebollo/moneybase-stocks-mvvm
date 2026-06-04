//
//  AppDIContainer.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import Foundation

final class AppDIContainer {
    private let repository: StocksRepository

    init(repository: StocksRepository = MockStocksRepository()) {
        self.repository = repository
    }

    func makeStocksListViewModel(shouldAutoRefresh: Bool) -> StocksListViewModel {
        StocksListViewModel(
            fetchStocksUseCase: FetchStocksUseCase(repository: repository),
            shouldAutoRefresh: shouldAutoRefresh)
    }

    func makeStockDetailViewModel(symbol: String) -> StockDetailViewModel {
        StockDetailViewModel(
            symbol: symbol,
            fetchStockProfileUseCase: FetchStockProfileUseCase(repository: repository)
        )
    }
}
