//
//  L10n.swift
//  Transactions-Demo
//
//  Created by Mohamed Abdulrahman on 05/11/2026.
//

import Foundation

enum L10n {
    enum Key: String {
        case appName
        case transactions
        case menu
        case language
        case loadingTransactions
        case noTransactions
        case noTransactionsHint
        case somethingWentWrong
        case tryAgain
        case settings
        case close
        case transactionFallback
    }

    private static let english: [Key: String] = [
        .appName: "Transactions",
        .transactions: "Transactions",
        .menu: "Menu",
        .language: "Language",
        .loadingTransactions: "Loading transactions…",
        .noTransactions: "No Transactions",
        .noTransactionsHint: "Pull to refresh or try again later.",
        .somethingWentWrong: "Something went wrong",
        .tryAgain: "Try Again",
        .settings: "Settings",
        .close: "Close",
        .transactionFallback: "Transaction"
    ]

    private static let arabic: [Key: String] = [
        .appName: "المعاملات",
        .transactions: "المعاملات",
        .menu: "القائمة",
        .language: "اللغة",
        .loadingTransactions: "جاري تحميل المعاملات…",
        .noTransactions: "لا توجد معاملات",
        .noTransactionsHint: "اسحب للتحديث أو حاول مرة أخرى لاحقاً.",
        .somethingWentWrong: "حدث خطأ ما",
        .tryAgain: "حاول مرة أخرى",
        .settings: "الإعدادات",
        .close: "إغلاق",
        .transactionFallback: "معاملة"
    ]

    static func string(_ key: Key, language: AppLanguage) -> String {
        switch language {
        case .english: return english[key] ?? key.rawValue
        case .arabic: return arabic[key] ?? key.rawValue
        }
    }

    static func category(_ value: String, language: AppLanguage) -> String {
        let map: [String: (en: String, ar: String)] = [
            "food": ("Food", "طعام"),
            "dining": ("Dining", "مطاعم"),
            "restaurants": ("Restaurants", "مطاعم"),
            "transport": ("Transport", "مواصلات"),
            "travel": ("Travel", "سفر"),
            "shopping": ("Shopping", "تسوق"),
            "entertainment": ("Entertainment", "ترفيه"),
            "income": ("Income", "دخل"),
            "salary": ("Salary", "راتب"),
            "fuel": ("Fuel", "وقود")
        ]
        guard let entry = map[value.lowercased()] else {
            return value.capitalized
        }
        return language == .arabic ? entry.ar : entry.en
    }

    static func status(_ value: String, language: AppLanguage) -> String {
        let map: [String: (en: String, ar: String)] = [
            "completed": ("Completed", "مكتمل"),
            "posted": ("Posted", "مرحّل"),
            "settled": ("Settled", "مسوّى"),
            "pending": ("Pending", "قيد الانتظار"),
            "failed": ("Failed", "فشل"),
            "declined": ("Declined", "مرفوض")
        ]
        guard let entry = map[value.lowercased()] else {
            return value.capitalized
        }
        return language == .arabic ? entry.ar : entry.en
    }
}
