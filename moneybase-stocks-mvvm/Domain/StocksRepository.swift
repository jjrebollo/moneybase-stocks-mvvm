import Foundation

protocol StocksRepository: Sendable {
    func fetchStocks() async throws -> [StockQuote]
    func fetchStockProfile(symbol: String) async throws -> StockProfile
}

enum StocksError: LocalizedError {
    case stockNotFound(String)

    var errorDescription: String? {
        switch self {
        case .stockNotFound(let symbol):
            return "Stock profile for \(symbol) was not found."
        }
    }
}
