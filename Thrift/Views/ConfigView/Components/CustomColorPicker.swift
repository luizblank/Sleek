//
//  CustomColorPicker.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 05/12/25.
//

import SwiftUI

struct CustomColorPicker: View {
    @Binding var changedColor: Color
    var label: String
    var key: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ColorPicker(selection: $changedColor){}
                .accessibilityLabel("Color picker")
                .accessibilityAddTraits(.allowsDirectInteraction)
                .accessibilityHint("Click here to select a \(label)")
                .scaleEffect(1.3)
                .frame(width: 36, height: 36)
                .onChange(of: changedColor) { _, newValue in
                    UserDefaults.standard.set(newValue.toHexString(), forKey: key)
                }
            Text(label)
                .sleekText(defaultText: true)
                .accessibilityHidden(true)
        }
    }
}

#Preview {
    CustomColorPicker(changedColor: .constant(Color(.sleekPink)), label: "Background color", key: "backgroundColor")
        .environmentObject(Config())
}
