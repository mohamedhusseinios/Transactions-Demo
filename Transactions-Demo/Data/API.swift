//
//  API.swift
//  Transactions-Demo
//
//  Created by Mohamed Abdulrahman on 05/11/2026.
//

import Foundation

class API {
    /// Demo flag — task asks to mock the API. Flip to `false` to hit the real endpoint.
    var useMock = true

    func fetchTransactions(page: Int = 1, limit: Int = 20) async throws -> TransactionsResponse {
        if useMock {
            return try await fetchMockTransactions(page: page, limit: limit)
        }
        return try await fetchRemoteTransactions(page: page, limit: limit)
    }

    private func fetchRemoteTransactions(page: Int, limit: Int) async throws -> TransactionsResponse {
        guard let url = URL(string: "https://api.sondahub.com/v1/bank/transactions?page=\(page)&limit=\(limit)") else {
            throw APIError.badURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw APIError.badResponse
        }
        do {
            return try JSONDecoder().decode(TransactionsResponse.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }

    private func fetchMockTransactions(page: Int, limit: Int) async throws -> TransactionsResponse {
        try await Task.sleep(for: .milliseconds(600))

        let total = 47
        let pages = Int(ceil(Double(total) / Double(limit)))
        guard page >= 1, page <= pages else {
            return TransactionsResponse(
                data: [],
                meta: PaginationMeta(page: page, limit: limit, total: total, pages: pages)
            )
        }

        let start = (page - 1) * limit
        let end = min(start + limit, total)
        let merchants = ["Cafe Nero", "Uber", "Amazon", "Spotify", "Payroll", "Shell", "Apple", "Netflix"]
        let categories = ["food", "transport", "shopping", "entertainment", "income", "fuel", "shopping", "entertainment"]
        let statuses = ["completed", "pending", "completed", "completed"]

        let data = (start..<end).map { index -> Transaction in
            let isCredit = index % 7 == 0
            return Transaction(
                id: index + 1,
                amount: Double((index % 9 + 1) * 12) + Double(index % 5) * 0.25,
                currency: "USD",
                description: isCredit ? "Incoming transfer" : "Card purchase",
                merchant: merchants[index % merchants.count],
                category: isCredit ? "income" : categories[index % categories.count],
                status: statuses[index % statuses.count],
                type: isCredit ? "credit" : "debit",
                bookedAt: ISO8601DateFormatter().string(
                    from: Date().addingTimeInterval(TimeInterval(-index * 3600 * 5))
                )
            )
        }

        return TransactionsResponse(
            data: data,
            meta: PaginationMeta(page: page, limit: limit, total: total, pages: pages)
        )
    }
}
