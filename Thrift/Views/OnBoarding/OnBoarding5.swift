//
//  OnBoarding5.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 01/05/26.
//

import SwiftUI

struct OnBoarding5: View {
    @EnvironmentObject var configModel: Config
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var containerSize: CGSize = .zero

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 16) {
                Image(systemName: "square.and.arrow.up.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.white)
                    .stroke()
                    .padding(.bottom, 8)
                    .accessibilityHidden(true)

                Text(String(localized: "Share to Sleek"))
                    .sleekText(.large)
                    .multilineTextAlignment(.center)
                Text(String(localized: "Found something you like?\nShare an image directly to\nSleek from other apps."))
                    .sleekText(.medium)
                    .multilineTextAlignment(.center)
            }

            Button {
                hasSeenOnboarding = true
            } label: {
                Text(String(localized: "Get started"))
                    .font(.customFont(name: configModel.font, size: 24, weight: .bold))
                    .frame(width: 180, height: 30)
                    .foregroundStyle(.black)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(.white)
                    .clipShape(Capsule())
                    .padding(.horizontal)
                    .stroke()
            }
            .accessibilityLabel(String(localized: "Get started"))
            .accessibilityAddTraits(.isButton)
            .accessibilityHint(String(localized: "Finish the onboarding and start using Sleek"))
            .position(x: containerSize.width / 2, y: containerSize.height * 0.85)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.sleekPink)
        .toolbar(.hidden, for: .navigationBar)
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newSize in
            containerSize = newSize
        }
    }
}

#Preview {
    NavigationStack {
        OnBoarding5()
            .environmentObject(Config())
    }
}
