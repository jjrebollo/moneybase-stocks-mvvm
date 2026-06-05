//
//  ContentView.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import SwiftUI

struct ContentView: View {
    private let listCoordinator: StocksListCoordinator

    init(container: AppDIContainer) {
        self.listCoordinator = container.makeStocksListCoordinator(shouldAutoRefresh: true)
    }

    var body: some View {
        StocksListCoordinatorView(coordinator: listCoordinator)
    }
}

#Preview {
    ContentView(container: AppDIContainer(repository: MockStocksRepository()))
}
