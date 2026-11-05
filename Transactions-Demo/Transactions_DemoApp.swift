//
//  Transactions_DemoApp.swift
//  Transactions-Demo
//
//  Created by Mohamed Abdulrahman on 05/11/2026.
//

import SwiftUI

@main
struct Transactions_DemoApp: App {
    @StateObject private var languageManager = LanguageManager()
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(languageManager)
                    // Set direction once at the root — never nest LTR/RTL overrides (that mirrors text).
                    .environment(\.locale, languageManager.language.locale)
                    .environment(\.layoutDirection, languageManager.language.layoutDirection)
                    .id(languageManager.language) // rebuild cleanly on language change

                if showSplash {
                    SplashView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .task {
                try? await Task.sleep(for: .seconds(1.4))
                withAnimation(.easeOut(duration: 0.35)) {
                    showSplash = false
                }
            }
        }
    }
}
