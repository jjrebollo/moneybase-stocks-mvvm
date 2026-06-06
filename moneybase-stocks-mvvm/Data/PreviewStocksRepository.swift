//
//  PreviewStocksRepository.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import Foundation

#if DEBUG
actor PreviewStocksRepository: StocksRepository {
    private let quotes: [StockQuote]
    private let profiles: [String: StockProfile]

    init(
        quotes: [StockQuote] = MockStockData.quotes,
        profiles: [String: StockProfile] = MockStockData.profiles
    ) {
        self.quotes = quotes
        self.profiles = profiles
    }

    func fetchStocks(page: Int) async throws -> [StockQuote] {
        guard page == 1 else {
            return []
        }

        return quotes.sorted { $0.marketCap > $1.marketCap }
    }

    func fetchStockProfile(symbol: String) async throws -> StockProfile {
        try await Task.sleep(for: .milliseconds(200))

        guard let profile = profiles[symbol] else {
            throw StocksError.stockNotFound(symbol)
        }

        return profile
    }
}

nonisolated enum MockStockData {
    static let quotes: [StockQuote] = [
        StockQuote(symbol: "AAPL", name: "Apple Inc.", lastPrice: 211.33, netChange: 2.13, percentChange: 1.02, marketCap: 3_200_000_000_000),
        StockQuote(symbol: "MSFT", name: "Microsoft Corporation", lastPrice: 428.70, netChange: -1.87, percentChange: -0.43, marketCap: 3_100_000_000_000),
        StockQuote(symbol: "NVDA", name: "NVIDIA Corporation", lastPrice: 1184.20, netChange: 14.89, percentChange: 1.27, marketCap: 2_900_000_000_000),
        StockQuote(symbol: "AMZN", name: "Amazon.com, Inc.", lastPrice: 189.04, netChange: 0.62, percentChange: 0.33, marketCap: 1_980_000_000_000),
        StockQuote(symbol: "GOOGL", name: "Alphabet Inc.", lastPrice: 177.51, netChange: -0.74, percentChange: -0.42, marketCap: 2_180_000_000_000),
        StockQuote(symbol: "TSLA", name: "Tesla, Inc.", lastPrice: 176.42, netChange: 3.82, percentChange: 2.21, marketCap: 563_000_000_000),
        StockQuote(symbol: "META", name: "Meta Platforms, Inc.", lastPrice: 507.66, netChange: -4.22, percentChange: -0.82, marketCap: 1_290_000_000_000),
        StockQuote(symbol: "NFLX", name: "Netflix, Inc.", lastPrice: 639.10, netChange: 1.40, percentChange: 0.22, marketCap: 274_000_000_000),
        StockQuote(symbol: "JPM", name: "JPMorgan Chase & Co.", lastPrice: 196.58, netChange: -0.33, percentChange: -0.17, marketCap: 562_000_000_000),
        StockQuote(symbol: "V", name: "Visa Inc.", lastPrice: 278.16, netChange: 0.91, percentChange: 0.33, marketCap: 579_000_000_000)
    ]

    static let profiles: [String: StockProfile] = [
        "AAPL": StockProfile(
            symbol: "AAPL",
            sector: "Technology",
            industry: "Consumer Electronics",
            website: "https://www.apple.com",
            summary: "Apple designs and sells consumer devices, software, and subscription services across global markets.",
            fullTimeEmployees: 166_000
        ),
        "MSFT": StockProfile(
            symbol: "MSFT",
            sector: "Technology",
            industry: "Software - Infrastructure",
            website: "https://www.microsoft.com",
            summary: "Microsoft builds cloud platforms, productivity software, AI services, and enterprise tooling.",
            fullTimeEmployees: 221_000
        ),
        "NVDA": StockProfile(
            symbol: "NVDA",
            sector: "Technology",
            industry: "Semiconductors",
            website: "https://www.nvidia.com",
            summary: "NVIDIA provides accelerated computing, GPUs, and AI platforms for data centers, gaming, and automotive.",
            fullTimeEmployees: 29_600
        ),
        "AMZN": StockProfile(
            symbol: "AMZN",
            sector: "Consumer Cyclical",
            industry: "Internet Retail",
            website: "https://www.amazon.com",
            summary: "Amazon runs global e-commerce, cloud infrastructure, and logistics networks.",
            fullTimeEmployees: 1_525_000
        ),
        "GOOGL": StockProfile(
            symbol: "GOOGL",
            sector: "Communication Services",
            industry: "Internet Content & Information",
            website: "https://abc.xyz",
            summary: "Alphabet operates search, ad-tech, cloud, and AI products through Google and other businesses.",
            fullTimeEmployees: 182_500
        ),
        "TSLA": StockProfile(
            symbol: "TSLA",
            sector: "Consumer Cyclical",
            industry: "Auto Manufacturers",
            website: "https://www.tesla.com",
            summary: "Tesla develops electric vehicles, batteries, software, and energy storage products.",
            fullTimeEmployees: 140_473
        ),
        "META": StockProfile(
            symbol: "META",
            sector: "Communication Services",
            industry: "Internet Content & Information",
            website: "https://about.meta.com",
            summary: "Meta builds social platforms, ad products, and reality labs hardware and software.",
            fullTimeEmployees: 67_317
        ),
        "NFLX": StockProfile(
            symbol: "NFLX",
            sector: "Communication Services",
            industry: "Entertainment",
            website: "https://www.netflix.com",
            summary: "Netflix offers streaming entertainment and original content worldwide.",
            fullTimeEmployees: 14_000
        ),
        "JPM": StockProfile(
            symbol: "JPM",
            sector: "Financial Services",
            industry: "Banks - Diversified",
            website: "https://www.jpmorganchase.com",
            summary: "JPMorgan provides consumer and investment banking, payments, and asset management globally.",
            fullTimeEmployees: 313_206
        ),
        "V": StockProfile(
            symbol: "V",
            sector: "Financial Services",
            industry: "Credit Services",
            website: "https://usa.visa.com",
            summary: "Visa operates global digital payments infrastructure connecting consumers, merchants, and banks.",
            fullTimeEmployees: 29_500
        )
    ]
}
#endif
