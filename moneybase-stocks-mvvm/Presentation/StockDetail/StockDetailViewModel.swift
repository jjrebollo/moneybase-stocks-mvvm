import Foundation
import Combine

@MainActor
final class StockDetailViewModel: ObservableObject {
    @Published private(set) var profile: StockProfile?
    @Published private(set) var isLoading = true
    @Published private(set) var errorMessage: String?

    let symbol: String

    private let fetchStockProfileUseCase: FetchStockProfileUseCaseProtocol

    init(symbol: String, fetchStockProfileUseCase: FetchStockProfileUseCaseProtocol) {
        self.symbol = symbol
        self.fetchStockProfileUseCase = fetchStockProfileUseCase
    }

    func loadIfNeeded() {
        Task {
            await loadIfNeededTask()
        }
    }
    
    func loadIfNeededTask() async {
        guard profile == nil else { return }

        await load()
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }

        do {
            profile = try await fetchStockProfileUseCase.execute(symbol: symbol)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
