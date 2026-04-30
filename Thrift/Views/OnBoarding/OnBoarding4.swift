//
//  OnBoarding4.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 29/04/26.
//

import SwiftUI

struct OnBoarding4: View {
    @EnvironmentObject var configModel: Config
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var containerSize: CGSize = .zero

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 16) {
                HStack(spacing: 32) {
                    Image(systemName: "basket.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundStyle(.white)
                        .stroke()

                    Image(systemName: "trash.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundStyle(.white)
                        .stroke()
                }
                .padding(.bottom, 8)

                Text("Drop it like it's hot")
                    .sleekText(.large)
                    .multilineTextAlignment(.center)
                Text("In edit mode, drag items\nto the basket to mark as bought,\nor to the trash to delete.")
                    .sleekText(.medium)
                    .multilineTextAlignment(.center)
            }

            Button {
                hasSeenOnboarding = true
            } label: {
                Text("Get started")
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
        OnBoarding4()
            .environmentObject(Config())
    }
}
