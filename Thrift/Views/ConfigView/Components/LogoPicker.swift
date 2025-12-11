//
//  LogoPicker.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 05/12/25.
//

import SwiftUI

struct LogoPicker: View {
    @EnvironmentObject var configModel: Config
    
    var body: some View {
        Menu {
            Picker("App logo", selection: $configModel.logo) {
                Text("Horizontal logo")
                    .tag("horizontalLogo")
                Text("Overlapped logo")
                    .tag("overlappedLogo")
                Text("Ball of wool")
                    .tag("ballOfWool")
                Text("Text only")
                    .tag("textOnly")
                Text("None")
                    .tag("")
            }
        } label: {
            HStack(alignment: .center) {
                if configModel.logo != "" {
                    Image(configModel.logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                        .fixedSize(horizontal: true, vertical: false)
                } else {
                    Text("None")
                        .sleekText(.medium, defaultText: true)
                }
                
                VStack(spacing: 0) {
                    Image(systemName: "chevron.up")
                        .sleekText(.small, defaultText: true)
                    Image(systemName: "chevron.down")
                        .sleekText(.small, defaultText: true)
                }
            }
        }
        .onChange(of: configModel.logo) { _, newValue in
            UserDefaults.standard.set(newValue, forKey: "logo")
        }
        .accessibilityLabel("Logo picker")
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Select a logo you like")
        .accessibilityInputLabels(LogoTypes.allCases.map(\.description))
        .accessibilityValue(LogoTypes(rawValue: configModel.logo)?.description ?? "None")
    }
}

enum LogoTypes: String, CaseIterable, Identifiable {
    case horizontal = "horizontalLogo"
    case overlapped = "overlappedLogo"
    case ballOfWool = "ballOfWool"
    case textOnly = "textOnly"
    case none = ""
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .horizontal: return String(localized: "Horizontal logo")
        case .overlapped: return String(localized: "Overlapped logo")
        case .ballOfWool: return String(localized: "Ball of wool")
        case .textOnly:   return String(localized: "Text only")
        case .none:       return String(localized: "None")
        }
    }
}

#Preview {
    LogoPicker()
        .environmentObject(Config())
}
