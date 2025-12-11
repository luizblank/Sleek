//
//  OnBoarding.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 15/10/25.
//

import SwiftUI

struct OnBoarding1: View {
    @EnvironmentObject var configModel: Config
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Image(.blankLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 130)
                
                Text("Welcome to Sleek!")
                    .sleekText(.large)
                Text("The stylish home\nfor everything you want.")
                    .sleekText(.medium)
                    .multilineTextAlignment(.center)
            }
            
            // joga esse next pro router depois
            NavigationLink {
                
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
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.85)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.sleekPink)
    }
}

#Preview {
    OnBoarding1()
        .environmentObject(Config())
}
