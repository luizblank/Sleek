//
//  TextField.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 10/10/25.
//

import SwiftUI

extension TextField {
    func formStyle(_ configModel: Config) -> some View {
        self
            .font(.customFont(name: configModel.font, size: 20))
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(.black.opacity(0.05))
            .clipShape(Capsule())
    }
}

extension View {
    func editModeStyle() -> some View {
        self
            .padding(12)
            .background(.black.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
