//
//  OnBoarding3.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 29/04/26.
//

import SwiftUI

struct OnBoarding3: View {
    @EnvironmentObject var configModel: Config

    @State private var wiggle: Bool = false
    @State private var containerSize: CGSize = .zero

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 16) {
                Image(systemName: "hand.tap.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundStyle(.white)
                    .stroke()
                    .rotationEffect(Angle(degrees: wiggle ? 6 : -6), anchor: .center)
                    .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: wiggle)
                    .padding(.bottom, 8)
                    .onAppear { wiggle = true }

                Text("Edit mode")
                    .sleekText(.large)
                Text("Hold any item to start\nrearranging your wishlist.")
                    .sleekText(.medium)
                    .multilineTextAlignment(.center)
            }

            NavigationLink {
                OnBoarding4()
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
        OnBoarding3()
            .environmentObject(Config())
    }
}
