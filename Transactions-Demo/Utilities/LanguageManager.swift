//
//  LanguageManager.swift
//  Transactions-Demo
//
//  Created by Mohamed Abdulrahman on 05/11/2026.
//

import Combine
import SwiftUI

@MainActor
final class LanguageManager: ObservableObject {
    private static let storageKey = "app.language"

    @Published var language: AppLanguage {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: Self.storageKey)
        }
    }

    init() {
        if let saved = UserDefaults.standard.string(forKey: Self.storageKey),
           let language = AppLanguage(rawValue: saved) {
            self.language = language
        } else {
            self.language = .english
        }
    }

    func text(_ key: L10n.Key) -> String {
        L10n.string(key, language: language)
    }

    func localizedCategory(_ category: TransactionCategory) -> String {
        L10n.category(category, language: language)
    }

    func localizedStatus(_ status: TransactionStatus) -> String {
        L10n.status(status, language: language)
    }
}
