//
//  StocksListViewModel.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import Foundation
import Combine

@MainActor
final class StocksListViewModel: BaseViewModel {
    @Published private(set) var stocks: [StockQuote] = []
    @Published var searchText = ""

    private let fetchStocksUseCase: any FetchStocksUseCaseProtocol
    private var refreshTask: Task<Void, Never>?
    private var shouldAutoRefresh: Bool

    init(fetchStocksUseCase: any FetchStocksUseCaseProtocol,
         shouldAutoRefresh: Bool) {
        self.shouldAutoRefresh = shouldAutoRefresh
        self.fetchStocksUseCase = fetchStocksUseCase
    }

    var filteredStocks: [StockQuote] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !query.isEmpty else {
            return stocks
        }

        return stocks.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.symbol.localizedCaseInsensitiveContains(query)
        }
    }

    func onAppear() async {
        if stocks.isEmpty {
            await refresh()
        }

        startAutoRefresh()
    }

    func onDisappear() {
        refreshTask?.cancel()
        refreshTask = nil
    }

    func refresh() async {
        await loadStocks(showLoader: true)
    }

    private func startAutoRefresh() {
        guard refreshTask == nil,
              shouldAutoRefresh else { return }

        refreshTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(8))

                guard !Task.isCancelled else { return }
                await self?.loadStocks(showLoader: false)
            }
        }
    }

    private func loadStocks(showLoader: Bool) async {
        let loadedStocks = await performLoading(showLoading: showLoader) {
            try await fetchStocksUseCase.execute()
        }

        if let loadedStocks {
            self.stocks = loadedStocks
        }
    }
}
