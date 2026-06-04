import Foundation

protocol FetchStocksUseCaseProtocol: Sendable {
    func execute() async throws -> [StockQuote]
}

protocol FetchStockProfileUseCaseProtocol: Sendable {
    func execute(symbol: String) async throws -> StockProfile
}

final class FetchStocksUseCase: BaseUseCase<[StockQuote]>, FetchStocksUseCaseProtocol {
    private let repository: StocksRepository

    init(repository: StocksRepository) {
        self.repository = repository
    }

    override func execute() async throws -> [StockQuote] {
        try await repository.fetchStocks()
    }
}

final class FetchStockProfileUseCase: BaseInputUseCase<String, StockProfile>, FetchStockProfileUseCaseProtocol {
    private let repository: StocksRepository

    init(repository: StocksRepository) {
        self.repository = repository
    }

    override func execute(_ symbol: String) async throws -> StockProfile {
        try await repository.fetchStockProfile(symbol: symbol)
    }

    func execute(symbol: String) async throws -> StockProfile {
        try await execute(symbol)
    }
}
