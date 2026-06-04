import Foundation

protocol FetchStocksUseCaseProtocol: Sendable {
    func execute() async throws -> [StockQuote]
}

protocol FetchStockProfileUseCaseProtocol: Sendable {
    func execute(symbol: String) async throws -> StockProfile
}

struct FetchStocksUseCase: FetchStocksUseCaseProtocol {
    private let repository: StocksRepository

    init(repository: StocksRepository) {
        self.repository = repository
    }

    func execute() async throws -> [StockQuote] {
        try await repository.fetchStocks()
    }
}

struct FetchStockProfileUseCase: FetchStockProfileUseCaseProtocol {
    private let repository: StocksRepository

    init(repository: StocksRepository) {
        self.repository = repository
    }

    func execute(symbol: String) async throws -> StockProfile {
        try await repository.fetchStockProfile(symbol: symbol)
    }
}
