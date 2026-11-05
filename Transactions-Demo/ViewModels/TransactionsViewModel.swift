//
//  TransactionsViewModel.swift
//  Transactions-Demo
//
//  Created by Mohamed Abdulrahman on 05/11/2026.
//

import Foundation
import Combine

@MainActor
final class TransactionsViewModel: ObservableObject {
    @Published private(set) var transactions: [Transaction] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isLoadingMore = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var hasMore = true

    private let api = API()
    private let pageSize = 20
    private var currentPage = 1
    private var totalPages = 1

    func loadInitial() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        currentPage = 1
        defer { isLoading = false }

        do {
            let response = try await api.fetchTransactions(page: currentPage, limit: pageSize)
            transactions = response.data
            totalPages = response.meta.pages
            hasMore = currentPage < totalPages
        } catch {
            errorMessage = error.localizedDescription
            hasMore = false
        }
    }

    func loadMore() async {
        guard hasMore, !isLoading, !isLoadingMore else { return }
        isLoadingMore = true
        errorMessage = nil
        defer { isLoadingMore = false }

        let nextPage = currentPage + 1
        do {
            let response = try await api.fetchTransactions(page: nextPage, limit: pageSize)
            transactions.append(contentsOf: response.data)
            currentPage = nextPage
            totalPages = response.meta.pages
            hasMore = currentPage < totalPages
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func refresh() async {
        currentPage = 1
        hasMore = true
        await loadInitial()
    }
}
