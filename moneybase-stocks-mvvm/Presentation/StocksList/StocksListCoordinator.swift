//
//  StocksListCoordinator.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Combine
import Foundation

@MainActor
final class StocksListCoordinator: ObservableObject {
    enum Route: Hashable {
        case stockDetail(symbol: String, name: String)
    }

    @Published var path: [Route] = []

    let viewModel: StocksListViewModel

    private let container: AppDIContainer

    init(container: AppDIContainer, shouldAutoRefresh: Bool = true) {
        self.container = container
        self.viewModel = container.makeStocksListViewModel(shouldAutoRefresh: shouldAutoRefresh)
    }

    func showStockDetail(symbol: String, name: String) {
        path.append(.stockDetail(symbol: symbol, name: name))
    }

    func makeStockDetailCoordinator(symbol: String, name: String) -> StockDetailCoordinator {
        container.makeStockDetailCoordinator(symbol: symbol, name: name)
    }
}
