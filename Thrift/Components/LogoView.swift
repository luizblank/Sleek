//
//  LogoView.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 02/12/25.
//

import SwiftUI

struct LogoView: View {
    @EnvironmentObject private var configModel: Config
    
    var body: some View {
        ZStack(alignment: .leading) {
            if configModel.logo == "" {}
            else {
                Image(configModel.logo)
                    .resizable()
                    .scaledToFit()
                    .opacity(0)
                    .accessibilityHidden(true)
                
                configModel.strokeColor
                    .mask(
                        Image(configModel.logo)
                            .resizable()
                            .interpolation(.high)
                            .scaledToFit()
                            .colorInvert()
                            .luminanceToAlpha()
                    )
                    .mask(
                        Image(configModel.logo)
                            .resizable()
                            .scaledToFit()
                    )
                
                configModel.textColor
                    .mask(
                        Image(configModel.logo)
                            .resizable()
                            .interpolation(.high)
                            .scaledToFit()
                            .luminanceToAlpha()
                    )
            }
        }
        .accessibilityLabel("Logo")
        .accessibilityAddTraits(.isImage)
        .accessibilityHint("App logo")
    }
}

#Preview {
    LogoView()
        .environmentObject(Config())
}
