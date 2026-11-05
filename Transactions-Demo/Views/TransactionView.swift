//
//  TransactionView.swift
//  Transactions-Demo
//
//  Created by Mohamed Abdulrahman on 05/11/2026.
//

import SwiftUI

struct TransactionView: View {
    @EnvironmentObject private var languageManager: LanguageManager
    let transaction: Transaction

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundStyle(amountColor)
                .frame(width: 36, height: 36)
                .background(amountColor.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)

                Text(languageManager.localizedCategory(transaction.category))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(formattedDate)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 4) {
                Text(formattedAmount)
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(amountColor)

                Text(languageManager.localizedStatus(transaction.status))
                    .font(.caption2.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(statusColor.opacity(0.15), in: Capsule())
                    .foregroundStyle(statusColor)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.background)
                .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }

    private var title: String {
        transaction.merchant
            ?? transaction.description
            ?? "\(languageManager.text(.transactionFallback)) #\(transaction.id)"
    }

    private var formattedAmount: String {
        let prefix = transaction.type == .debit ? "-" : "+"
        let amount = transaction.amount.formatted(
            .number.precision(.fractionLength(2)).locale(languageManager.language.locale)
        )
        return "\(prefix)\(amount) \(transaction.currency)"
    }

    private var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: transaction.bookedAt)
            ?? ISO8601DateFormatter().date(from: transaction.bookedAt) {
            return date.formatted(
                .dateTime.day().month(.abbreviated).year().hour().minute()
                    .locale(languageManager.language.locale)
            )
        }
        return transaction.bookedAt
    }

    private var amountColor: Color {
        transaction.type == .debit ? .red : .green
    }

    private var statusColor: Color {
        switch transaction.status {
        case .completed, .posted, .settled: return .green
        case .pending: return .orange
        case .failed, .declined: return .red
        case .unknown: return .secondary
        }
    }

    private var iconName: String {
        switch transaction.category {
        case .food, .dining, .restaurants: return "fork.knife"
        case .transport, .travel: return "car"
        case .shopping: return "bag"
        case .income, .salary: return "arrow.down.circle"
        case .entertainment, .fuel, .unknown:
            return transaction.type == .debit ? "arrow.up.right" : "arrow.down.left"
        }
    }
}

#Preview {
    TransactionView(
        transaction: Transaction(
            id: 1,
            amount: 42.5,
            currency: "USD",
            description: "Lunch",
            merchant: "Cafe Nero",
            category: .food,
            status: .completed,
            type: .debit,
            bookedAt: "2026-11-05T12:00:00Z"
        )
    )
    .padding()
    .background(Color.primary.opacity(0.04))
    .environmentObject(LanguageManager())
}
