//
//  moneybase_stocks_mvvmApp.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import SwiftUI

@main
struct moneybase_stocks_mvvmApp: App {
    private let container = AppDIContainer()

    var body: some Scene {
        WindowGroup {
            ContentView(container: container)
        }
    }
}
