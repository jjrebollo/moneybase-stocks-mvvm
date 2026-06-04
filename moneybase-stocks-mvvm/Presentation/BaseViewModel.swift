//
//  BaseViewModel.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import Combine
import Foundation

@MainActor
class BaseViewModel: ObservableObject {
    @Published private(set) var isLoading = true
    @Published private(set) var errorMessage: String?

    func performLoading<T>(showLoading: Bool = true, _ work: () async throws -> T) async -> T? {
        if showLoading {
            isLoading = true
        }

        defer {
            if showLoading {
                isLoading = false
            }
        }

        do {
            let value = try await work()
            errorMessage = nil
            return value
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
}
