//
//  OnBoarding2.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 29/04/26.
//

import SwiftUI

struct OnBoarding2: View {
    @EnvironmentObject var configModel: Config
    @State private var containerSize: CGSize = .zero

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 16) {
                Image(systemName: "cabinet.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 130, height: 130)
                    .foregroundStyle(.white)
                    .stroke()
                    .padding(.bottom, 8)
                    .accessibilityHidden(true)

                Text("Your wardrobe")
                    .sleekText(.large)
                Text("A cozy spot for everything\nyou already own.")
                    .sleekText(.medium)
                    .multilineTextAlignment(.center)
            }

            NavigationLink {
                OnBoarding3()
            } label: {
                Text("Next")
                    .font(.customFont(name: configModel.font, size: 24, weight: .bold))
                    .frame(width: 140, height: 30)
                    .foregroundStyle(.black)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(.white)
                    .clipShape(Capsule())
                    .padding(.horizontal)
                    .stroke()
            }
            .accessibilityLabel("Next")
            .accessibilityAddTraits(.isButton)
            .accessibilityHint("Continue to the next onboarding screen")
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
        OnBoarding2()
            .environmentObject(Config())
    }
}
