//
//  Configuration.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 02/12/25.
//

import SwiftUI

struct ConfigView: View {
    @EnvironmentObject private var configModel: Config
    @Environment(\.dismiss) var dismiss
    
    @State private var rotate1: Double = 0
    @State private var rotate2: Double = 0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    Text("Settings")
                        .sleekText(.extraLarge, defaultText: true)

                    VStack(alignment: .leading) {
                        Text("Choose your favorite logo:")
                            .sleekText(.medium, defaultText: true)
                        LogoPicker()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Customize colors:")
                            .sleekText(.medium, defaultText: true)
                        CustomColorPicker(changedColor: $configModel.backgroundColor, label: String(localized: "Background color"), key: "backgroundColor")
                        CustomColorPicker(changedColor: $configModel.textColor, label: String(localized: "Text color"), key: "textColor")
                        CustomColorPicker(changedColor: $configModel.strokeColor, label: String(localized: "Stroke color"), key: "strokeColor")
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Tired of colors? Add an image:")
                            .sleekText(.medium, defaultText: true)
                        BackgroundPicker()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("What about a new font?")
                            .sleekText(.medium, defaultText: true)
                        FontPicker()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("App options")
                            .sleekText(.medium, defaultText: true)
                            .padding(.bottom, 4)
                        ResetButton(String(localized: "Reset settings to default")) {
                            configModel.resetConfig()
                        }
                        .accessibilityLabel("Reset settings button")
                        .accessibilityAddTraits(.isButton)
                        .accessibilityHint("Click here to reset all your settings to their default values")
//                        ResetButton(String(localized: "Reset OnBoarding")) {
//                            
//                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(.sleekPink)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                            .font(.system(size: 24))
                            .stroke(.black)
                            .frame(width: 36, height: 36)
                    }
                }
            }
        }
    }
}

#Preview {
    ConfigView()
        .environmentObject(Config())
}
