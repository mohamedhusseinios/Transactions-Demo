//
//  TransactionEnums.swift
//  Transactions-Demo
//
//  Created by Mohamed Abdulrahman on 05/11/2026.
//

import Foundation

enum TransactionStatus: String, Codable {
    case completed, posted, settled, pending, failed, declined, unknown

    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = TransactionStatus(rawValue: raw.lowercased()) ?? .unknown
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

enum TransactionCategory: String, Codable {
    case food, dining, restaurants, transport, travel, shopping
    case entertainment, income, salary, fuel, unknown

    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = TransactionCategory(rawValue: raw.lowercased()) ?? .unknown
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

enum TransactionType: String, Codable {
    case debit, credit, unknown

    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = TransactionType(rawValue: raw.lowercased()) ?? .unknown
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
