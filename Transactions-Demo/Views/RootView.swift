//
//  RootView.swift
//  Transactions-Demo
//
//  Created by Mohamed Abdulrahman on 05/11/2026.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @State private var isMenuOpen = false

    private let menuWidth: CGFloat = 300

    var body: some View {
        ZStack(alignment: .leading) {
            TransactionsView(isMenuOpen: $isMenuOpen)
                .disabled(isMenuOpen)

            if isMenuOpen {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture(perform: closeMenu)
            }

            SideMenuView(languageManager: languageManager, onClose: closeMenu)
                .frame(width: menuWidth)
                .frame(maxHeight: .infinity)
                .background(.background)
                .shadow(color: .black.opacity(isMenuOpen ? 0.2 : 0), radius: 12, x: 4)
                .contentShape(Rectangle())
                .offset(x: menuOffset)
                .allowsHitTesting(isMenuOpen)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut(duration: 0.25), value: isMenuOpen)
    }

    /// Closed offset is always negative. SwiftUI flips the x axis in RTL,
    /// so -width slides off the leading edge in both English and Arabic.
    private var menuOffset: CGFloat {
        isMenuOpen ? 0 : -menuWidth
    }

    private func closeMenu() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isMenuOpen = false
        }
    }
}

#Preview {
    RootView()
        .environmentObject(LanguageManager())
}
