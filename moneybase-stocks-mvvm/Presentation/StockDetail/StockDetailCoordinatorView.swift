//
//  StockDetailCoordinatorView.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import SwiftUI

struct StockDetailCoordinatorView: View {
    @StateObject private var coordinator: StockDetailCoordinator

    init(coordinator: StockDetailCoordinator) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }

    var body: some View {
        StockDetailView(viewModel: coordinator.viewModel)
    }
}

#Preview {
    StockDetailCoordinatorView(
        coordinator: AppDIContainer().makeStockDetailCoordinator(symbol: "AAPL")
    )
}
