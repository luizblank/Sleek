//
//  Background.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 05/12/25.
//

import SwiftUI

struct Background: View {
    @EnvironmentObject var configModel: Config
    
    var body: some View {
        if let bgImage = configModel.backgroundImage {
            Image(uiImage: bgImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        } else {
            configModel.backgroundColor
                .ignoresSafeArea()
        }
    }
}
