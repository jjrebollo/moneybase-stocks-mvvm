//
//  AppLogger.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Foundation

final class AppLogger {
    static func debug(
        _ message: @autoclosure () -> String,
        category: AppLoggerCategory = .general,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
#if DEBUG
        print("[DEBUG][\(category)] \(message()) | \(file):\(line) \(function)")
#endif
    }
}

enum AppLoggerCategory: String {
    case general = "General"
    case network = "Network"
}
