//
//  StockDetailCoordinator.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Combine
import Foundation

@MainActor
final class StockDetailCoordinator: ObservableObject {
    let symbol: String
    let name: String
    let viewModel: StockDetailViewModel

    init(symbol: String, name: String, container: AppDIContainer) {
        self.symbol = symbol
        self.name = name
        self.viewModel = container.makeStockDetailViewModel(symbol: symbol, name: name)
    }
}
