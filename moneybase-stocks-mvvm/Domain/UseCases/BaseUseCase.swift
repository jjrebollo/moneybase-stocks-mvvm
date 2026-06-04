//
//  BaseUseCase.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import Foundation

protocol BaseUseCaseProtocol<Input, Output> {
    associatedtype Input
    associatedtype Output
    
    func execute(_ input: Input?) async throws -> Output
    func handle(input: Input?) async throws -> Output
}

extension BaseUseCaseProtocol {
    func execute(_ input: Input? = nil) async throws -> Output {
        try await handle(input: input)
    }
}
