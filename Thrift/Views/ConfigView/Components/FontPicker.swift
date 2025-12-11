//
//  FontPicker.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 05/12/25.
//

import SwiftUI

struct FontPicker: View {
    @EnvironmentObject var configModel: Config
    
    var body: some View {
        Picker("Custom font", selection: $configModel.font) {
            ForEach(AppFont.allCases) { font in
                Text(font.displayName)
                    .font(.customFont(name: font.rawValue, size: 20))
                    .foregroundStyle(.white)
                    .stroke(.black)
                    .tag(font)
            }
        }
        .accessibilityLabel("Font picker")
        .accessibilityHint("Select a font you like for your app")
        .accessibilityInputLabels(AppFont.allCases.map(\.rawValue))
        .accessibilityValue(configModel.font) // por algum motivo isso aqui nao funciona
        .pickerStyle(.wheel)
        .frame(height: 84)
        .onChange(of: configModel.font) { _, newValue in
            UserDefaults.standard.set(newValue, forKey: "font")
        }
    }
}

#Preview {
    FontPicker()
        .environmentObject(Config())
}
