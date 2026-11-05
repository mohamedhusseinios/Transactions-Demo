//
//  TransactionsView.swift
//  Transactions-Demo
//
//  Created by Mohamed Abdulrahman on 05/11/2026.
//

import SwiftUI

struct TransactionsView: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @StateObject private var viewModel = TransactionsViewModel()
    @Binding var isMenuOpen: Bool

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.transactions.isEmpty {
                    loadingView
                } else if let errorMessage = viewModel.errorMessage, viewModel.transactions.isEmpty {
                    errorView(message: errorMessage)
                } else if viewModel.transactions.isEmpty {
                    emptyView
                } else {
                    transactionsList
                }
            }
            .navigationTitle(languageManager.text(.transactions))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isMenuOpen.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.body.weight(.semibold))
                    }
                    .accessibilityLabel(languageManager.text(.menu))
                }
            }
            .task {
                await viewModel.loadInitial()
            }
        }
    }

    private var transactionsList: some View {
        List {
            ForEach(viewModel.transactions) { transaction in
                TransactionView(transaction: transaction)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .onAppear {
                        if transaction.id == viewModel.transactions.last?.id {
                            Task { await viewModel.loadMore() }
                        }
                    }
            }

            if viewModel.isLoadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.primary.opacity(0.04))
        .refreshable {
            await viewModel.refresh()
        }
        .overlay(alignment: .bottom) {
            if let errorMessage = viewModel.errorMessage, !viewModel.transactions.isEmpty {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.red.opacity(0.9), in: Capsule())
                    .padding(.bottom, 12)
            }
        }
    }

    private var loadingView: some View {
        ProgressView(languageManager.text(.loadingTransactions))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyView: some View {
        ContentUnavailableView(
            languageManager.text(.noTransactions),
            systemImage: "list.bullet.rectangle",
            description: Text(languageManager.text(.noTransactionsHint))
        )
        .refreshable {
            await viewModel.refresh()
        }
    }

    private func errorView(message: String) -> some View {
        ContentUnavailableView {
            Label(languageManager.text(.somethingWentWrong), systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button(languageManager.text(.tryAgain)) {
                Task { await viewModel.loadInitial() }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    TransactionsView(isMenuOpen: .constant(false))
        .environmentObject(LanguageManager())
}
