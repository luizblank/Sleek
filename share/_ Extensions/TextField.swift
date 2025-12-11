//
//  TextField.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 10/10/25.
//

import SwiftUI

extension TextField {
    func formStyle() -> some View {
        self
            .font(.antonio(size: 20))
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(.black.opacity(0.05))
            .clipShape(Capsule())
    }
}
