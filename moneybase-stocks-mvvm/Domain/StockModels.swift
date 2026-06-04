import Foundation

struct StockQuote: Identifiable, Equatable, Sendable {
    let symbol: String
    let name: String
    var lastPrice: Double
    var netChange: Double
    var percentChange: Double
    var marketCap: Double

    var id: String { symbol }

    var lastPriceText: String {
        StocksFormatting.currency(lastPrice)
    }

    var netChangeText: String {
        StocksFormatting.signedNumber(netChange)
    }

    var percentChangeText: String {
        StocksFormatting.signedPercent(percentChange)
    }

    var marketCapText: String {
        StocksFormatting.marketCap(marketCap)
    }

    var isPositiveChange: Bool {
        netChange >= 0
    }
}

struct StockProfile: Equatable, Sendable {
    let symbol: String
    let companyName: String
    let sector: String
    let industry: String
    let website: String
    let summary: String
    let fullTimeEmployees: Int
}

enum StocksFormatting {
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()

    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()

    static func currency(_ value: Double) -> String {
        currencyFormatter.string(from: NSNumber(value: value)) ?? String(format: "$%.2f", value)
    }

    static func signedNumber(_ value: Double) -> String {
        let body = numberFormatter.string(from: NSNumber(value: abs(value))) ?? String(format: "%.2f", abs(value))
        return value >= 0 ? "+\(body)" : "-\(body)"
    }

    static func signedPercent(_ value: Double) -> String {
        let body = numberFormatter.string(from: NSNumber(value: abs(value))) ?? String(format: "%.2f", abs(value))
        return value >= 0 ? "+\(body)%" : "-\(body)%"
    }

    static func marketCap(_ value: Double) -> String {
        let trillion = 1_000_000_000_000.0
        let billion = 1_000_000_000.0
        let million = 1_000_000.0

        if value >= trillion {
            return String(format: "$%.2fT", value / trillion)
        }

        if value >= billion {
            return String(format: "$%.2fB", value / billion)
        }

        if value >= million {
            return String(format: "$%.2fM", value / million)
        }

        return StocksFormatting.currency(value)
    }
}
