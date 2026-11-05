//
//  TransactionsResponse.swift
//  Transactions-Demo
//
//  Created by Mohamed Abdulrahman on 05/11/2026.
//

struct PaginationMeta: Codable {
    let page: Int
    let limit: Int
    let total: Int
    let pages: Int
}

struct TransactionsResponse: Codable {
    let data: [Transaction]
    let meta: PaginationMeta
}

struct Transaction: Codable, Identifiable {
    let id: Int
    let amount: Double
    let currency: String
    let description: String?
    let merchant: String?
    let category: TransactionCategory
    let status: TransactionStatus
    let type: TransactionType
    let bookedAt: String
    enum CodingKeys: String, CodingKey {
        case id, amount, currency, description, merchant, category, status, type
        case bookedAt = "booked_at"
    }
}
