import Foundation
import Combine

@MainActor
final class StocksListViewModel: ObservableObject {
    @Published private(set) var stocks: [StockQuote] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var searchText = ""

    private let fetchStocksUseCase: FetchStocksUseCaseProtocol
    private var refreshTask: Task<Void, Never>?

    init(fetchStocksUseCase: FetchStocksUseCaseProtocol) {
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
        guard refreshTask == nil else { return }

        refreshTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(8))

                guard !Task.isCancelled else { return }
                await self?.loadStocks(showLoader: false)
            }
        }
    }

    private func loadStocks(showLoader: Bool) async {
        if showLoader {
            isLoading = true
        }

        defer {
            if showLoader {
                isLoading = false
            }
        }

        do {
            stocks = try await fetchStocksUseCase.execute()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
