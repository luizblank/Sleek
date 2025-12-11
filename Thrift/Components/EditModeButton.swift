//
//  EditModeButton.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 08/10/25.
//

import SwiftUI

struct EditModeButton: View {
    @EnvironmentObject private var configModel: Config
    
    var icon: String
    var text: String

    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: icon)
                .sleekText(.large, weight: .bold)
                .frame(width: 48, height: 48)
                .background(configModel.textColor)
                .clipShape(Circle())
                .stroke()
            Text(text)
                .sleekText(.small)
        }
        .frame(width: 100)
    }
}

#Preview {
    HomeView(selectedView: .constant(0))
        .environmentObject(Config())
}
