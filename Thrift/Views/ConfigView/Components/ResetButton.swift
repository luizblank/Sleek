//
//  ResetButton.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 05/12/25.
//

import SwiftUI

struct ResetButton: View {
    var label: String
    var action: () -> Void
    
    @State private var rotate: Double = 0
    
    init(_ label: String, action: @escaping () -> Void) {
            self.label = label
            self.action = action
        }
    
    var body: some View {
        Button {
            action()
            rotate += 360
        } label: {
            HStack(alignment: .center, spacing: 2) {
                Text(label)
                    .sleekText(defaultText: true)
                Image(systemName: "arrow.clockwise.circle.fill")
                    .sleekText(.medium, defaultText: true)
                    .rotationEffect(Angle(degrees: rotate))
            }
        }
    }
}

#Preview {
    ResetButton("Legal") {
        print("banana")
    }
    .environmentObject(Config())
}
