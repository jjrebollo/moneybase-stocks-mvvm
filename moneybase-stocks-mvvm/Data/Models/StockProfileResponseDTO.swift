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
            sector: body.sector,
            industry: body.industry,
            website: body.website,
            summary: body.longBusinessSummary,
            fullTimeEmployees: body.fullTimeEmployees
        )
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
