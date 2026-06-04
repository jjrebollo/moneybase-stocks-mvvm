//
//  StockProfile.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import Foundation

struct StockProfile: Equatable, Sendable {
    let symbol: String
    let companyName: String
    let sector: String
    let industry: String
    let website: String
    let summary: String
    let fullTimeEmployees: Int
}
