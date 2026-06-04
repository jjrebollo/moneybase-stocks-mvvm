//
//  ContentView.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import SwiftUI

struct ContentView: View {
    private let container: AppDIContainer

    private let listViewModel: StocksListViewModel

    init(container: AppDIContainer) {
        self.container = container
        self.listViewModel = container.makeStocksListViewModel()
    }

    var body: some View {
        StocksListView(
            viewModel: listViewModel,
            makeStockDetailViewModel: container.makeStockDetailViewModel(symbol:)
        )
    }
}

#Preview {
    ContentView(container: AppDIContainer())
}
