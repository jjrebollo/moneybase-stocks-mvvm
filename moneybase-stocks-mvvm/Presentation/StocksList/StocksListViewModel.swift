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
    @Published private(set) var isLoadingNextPage = false
    @Published private(set) var showRefreshAvailableCTA = false
    @Published private(set) var scrollToTopTrigger = false
    @Published var searchText = ""

    private let fetchStocksUseCase: any FetchStocksUseCaseProtocol
    private var refreshTask: Task<Void, Never>?
    private var shouldAutoRefresh: Bool

    private var currentPage = 1
    private var hasMorePages = true
    private var isUserAtTop = true
    private var isRefreshingPageOne = false

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
            await resetAndLoadPageOne(showLoader: true)
        }

        startAutoRefresh()
    }

    func onDisappear() {
        refreshTask?.cancel()
        refreshTask = nil
    }

    func refresh() async {
        await resetAndLoadPageOne(showLoader: false)
    }

    func refreshFromCTA() async {
        showRefreshAvailableCTA = false
        await resetAndLoadPageOne(showLoader: true)
        scrollToTopTrigger.toggle()
    }

    func setUserAtTop(_ isAtTop: Bool) {
        isUserAtTop = isAtTop
    }

    func loadNextPageIfNeeded(currentItem: StockQuote) async {
        guard hasMorePages else { return }
        guard !isLoadingNextPage else { return }
        guard !isRefreshingPageOne else { return }
        guard currentItem.id == stocks.last?.id else { return }

        let nextPage = currentPage + 1
        isLoadingNextPage = true
        defer { isLoadingNextPage = false }

        guard let pageStocks = await performLoading(showLoading: false, {
            try await fetchStocksUseCase.execute(nextPage)
        }) else {
            return
        }

        guard !pageStocks.isEmpty else {
            hasMorePages = false
            return
        }

        stocks.append(contentsOf: pageStocks)
        currentPage = nextPage
    }

    private func startAutoRefresh() {
        guard refreshTask == nil,
              shouldAutoRefresh else { return }

        refreshTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 8_000_000_000)
                guard !Task.isCancelled else { return }

                if isUserAtTop {
                    await resetAndLoadPageOne(showLoader: false)
                } else {
                    showRefreshAvailableCTA = true
                }
            }
        }
    }

    private func resetAndLoadPageOne(showLoader: Bool) async {
        guard !isRefreshingPageOne else { return }
        isRefreshingPageOne = true
        defer { isRefreshingPageOne = false }

        await performLoading(showLoading: showLoader) {
            let firstPageStocks = try await fetchStocksUseCase.execute(1)
            stocks = firstPageStocks
            currentPage = 1
            hasMorePages = !firstPageStocks.isEmpty
        }
    }
}
