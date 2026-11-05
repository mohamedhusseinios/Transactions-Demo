//
//  SplashView.swift
//  Transactions-Demo
//
//  Created by Mohamed Abdulrahman on 05/11/2026.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color("SplashBackground")
                .ignoresSafeArea()

            Image("SplashLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .accessibilityLabel("Transactions")
        }
    }
}

#Preview {
    SplashView()
}
