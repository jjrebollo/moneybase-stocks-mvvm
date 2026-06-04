//
//  StockDetailViewModel.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import Foundation
import Combine

@MainActor
final class StockDetailViewModel: BaseViewModel {
    @Published private(set) var profile: StockProfile?

    let symbol: String

    private let fetchStockProfileUseCase: any FetchStockProfileUseCaseProtocol

    init(symbol: String, fetchStockProfileUseCase: any FetchStockProfileUseCaseProtocol) {
        self.symbol = symbol
        self.fetchStockProfileUseCase = fetchStockProfileUseCase
    }

    func loadIfNeeded() async {
        guard profile == nil else { return }

        await load()
    }

    func load() async {
        let loadedProfile = await performLoading {
            try await fetchStockProfileUseCase.execute(symbol)
        }

        if let loadedProfile {
            self.profile = loadedProfile
        }
    }
}
