//
//  Subtitle.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 09/10/25.
//

import SwiftUI

struct Subtitle: View {
    @EnvironmentObject private var configModel: Config
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.customFont(name: configModel.font, size: 24))
            .foregroundStyle(configModel.textColor)
            .stroke()
            .lineLimit(1)
    }
}
