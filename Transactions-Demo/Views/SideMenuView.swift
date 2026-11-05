//
//  SideMenuView.swift
//  Transactions-Demo
//
//  Created by Mohamed Abdulrahman on 05/11/2026.
//

import SwiftUI

struct SideMenuView: View {
    @ObservedObject var languageManager: LanguageManager
    var onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(languageManager.text(.menu))
                    .font(.title2.weight(.bold))
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 32, height: 32)
                        .background(Color.primary.opacity(0.06), in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(languageManager.text(.close))
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 20)

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                Label(languageManager.text(.settings), systemImage: "gearshape")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                Text(languageManager.text(.language))
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                VStack(spacing: 10) {
                    ForEach(AppLanguage.allCases) { language in
                        languageRow(language)
                    }
                }
                .padding(.horizontal, 16)
            }

            Spacer()

            Text(languageManager.text(.appName))
                .font(.footnote)
                .foregroundStyle(.tertiary)
                .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(.background)
    }

    private func languageRow(_ language: AppLanguage) -> some View {
        let isSelected = languageManager.language == language
        return Button {
            // Avoid animating layoutDirection under the finger — that was closing the drawer in Arabic.
            languageManager.language = language
        } label: {
            HStack(spacing: 12) {
                Image(systemName: language == .arabic ? "globe.asia.australia.fill" : "globe.americas.fill")
                    .foregroundStyle(isSelected ? .white : .primary)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 2) {
                    Text(language.displayName)
                        .font(.body.weight(.semibold))
                    Text(language.nativeLabel)
                        .font(.caption)
                        .foregroundStyle(isSelected ? .white.opacity(0.85) : .secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isSelected ? Color.accentColor : Color.primary.opacity(0.05))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(isSelected ? Color.clear : Color.primary.opacity(0.08), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .foregroundStyle(isSelected ? .white : .primary)
    }
}

#Preview {
    SideMenuView(languageManager: LanguageManager(), onClose: {})
        .frame(width: 300)
}
