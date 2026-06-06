//
//  StocksListResponseDTO.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Foundation

nonisolated struct StocksListResponseDTO: Decodable {
    let body: [StockListItemDTO]?
    
    func parseToDomainModel() -> [StockQuote] {
        (body ?? []).compactMap { $0.parseToDomainModel() }
    }
}

nonisolated struct StockListItemDTO: Decodable {
    let symbol: String
    let name: String
    let lastSale: String
    let netChange: String
    let percentChange: String
    let marketCap: String

    enum CodingKeys: String, CodingKey {
        case symbol
        case name
        case lastSale = "lastsale"
        case netChange = "netchange"
        case percentChange = "pctchange"
        case marketCap
    }
    
    func parseToDomainModel() -> StockQuote? {
        guard
            let lastPrice = parseCurrency(lastSale),
            let netChange = parseNumber(netChange),
            let percentChange = parsePercent(percentChange),
            let marketCap = parseNumber(marketCap)
        else {
            return nil
        }

        return StockQuote(
            symbol: symbol,
            name: name,
            lastPrice: lastPrice,
            netChange: netChange,
            percentChange: percentChange,
            marketCap: marketCap
        )
    }
    
    private func parseCurrency(_ value: String) -> Double? {
        parseNumber(value.replacingOccurrences(of: "$", with: ""))
    }

    private func parsePercent(_ value: String) -> Double? {
        parseNumber(value.replacingOccurrences(of: "%", with: ""))
    }

    private func parseNumber(_ value: String) -> Double? {
        let cleaned = value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: "")
        return Double(cleaned)
    }
}
