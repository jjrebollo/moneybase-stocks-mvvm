//
//  StockProfileResponseDTO.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Foundation

struct StockProfileResponseDTO: Decodable {
    let meta: StockProfileMetaDTO
    let body: StockProfileBodyDTO
    
    func parseToDomainModel() -> StockProfile {
        StockProfile(
            symbol: meta.symbol,
            companyName: extractCompanyName(),
            sector: body.sector,
            industry: body.industry,
            website: body.website,
            summary: body.longBusinessSummary,
            fullTimeEmployees: body.fullTimeEmployees
        )
    }
    
    private func extractCompanyName() -> String {
        let trimmedSummary = body.longBusinessSummary.trimmingCharacters(in: .whitespacesAndNewlines)
        let fallback = meta.symbol

        guard !trimmedSummary.isEmpty else {
            return fallback
        }

        if let range = trimmedSummary.range(of: " designs") {
            return String(trimmedSummary[..<range.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
        }

        if let firstSentence = trimmedSummary.split(separator: ".").first {
            let candidate = firstSentence.trimmingCharacters(in: .whitespacesAndNewlines)
            if !candidate.isEmpty {
                return candidate
            }
        }

        return fallback
    }
}

struct StockProfileMetaDTO: Decodable {
    let symbol: String
}

struct StockProfileBodyDTO: Decodable {
    let website: String
    let industry: String
    let sector: String
    let longBusinessSummary: String
    let fullTimeEmployees: Int
}
