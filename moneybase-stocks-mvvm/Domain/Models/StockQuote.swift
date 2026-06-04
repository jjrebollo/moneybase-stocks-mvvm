//
//  StockQuote.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

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
        StocksFormattingHelper.currency(lastPrice)
    }

    var netChangeText: String {
        StocksFormattingHelper.signedNumber(netChange)
    }

    var percentChangeText: String {
        StocksFormattingHelper.signedPercent(percentChange)
    }

    var marketCapText: String {
        StocksFormattingHelper.marketCap(marketCap)
    }

    var isPositiveChange: Bool {
        netChange >= 0
    }
}
