//
//  StocksListCoordinatorView.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import SwiftUI

struct StocksListCoordinatorView: View {
    @StateObject private var coordinator: StocksListCoordinator

    init(coordinator: StocksListCoordinator) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            StocksListView(
                viewModel: coordinator.viewModel,
                onSelectStock: coordinator.showStockDetail(symbol:name:)
            )
            .navigationDestination(for: StocksListCoordinator.Route.self) { route in
                switch route {
                case .stockDetail(let symbol, let name):
                    StockDetailCoordinatorView(
                        coordinator: coordinator.makeStockDetailCoordinator(symbol: symbol, name: name)
                    )
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    let previewContainer = AppDIContainer(repository: PreviewStocksRepository())

    StocksListCoordinatorView(
        coordinator: previewContainer.makeStocksListCoordinator(shouldAutoRefresh: false)
    )
}
#endif
