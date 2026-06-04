import Foundation

final class AppDIContainer {
    private let repository: StocksRepository

    init(repository: StocksRepository = MockStocksRepository()) {
        self.repository = repository
    }

    func makeStocksListViewModel() -> StocksListViewModel {
        StocksListViewModel(fetchStocksUseCase: FetchStocksUseCase(repository: repository))
    }

    func makeStockDetailViewModel(symbol: String) -> StockDetailViewModel {
        StockDetailViewModel(
            symbol: symbol,
            fetchStockProfileUseCase: FetchStockProfileUseCase(repository: repository)
        )
    }
}
