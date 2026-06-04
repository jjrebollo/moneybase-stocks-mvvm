//
//  StocksFormattingHelper.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import Foundation

enum StocksFormattingHelper {
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

        return StocksFormattingHelper.currency(value)
    }
}
