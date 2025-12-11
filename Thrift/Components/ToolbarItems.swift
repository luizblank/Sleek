//
//  ToolbarItems.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 05/12/25.
//

import SwiftUI

struct ToolbarItems: ToolbarContent {
    @EnvironmentObject private var configModel: Config
    @Binding var showFilterSheet: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            LogoView()
                .frame(height: 46)
                .fixedSize(horizontal: true, vertical: false)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            HStack {
                Button {
                    showFilterSheet.toggle()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .sleekText(.medium)
                        .frame(width: 36, height: 36)
                        .accessibilityLabel("Filter")
                        .accessibilityAddTraits(.isButton)
                        .accessibilityHint("Open the filter to select the registered categories")
                }
                
                NavigationLink {
                    ConfigView()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .sleekText(.medium)
                        .frame(width: 36, height: 36)
                        .accessibilityLabel("Settings")
                        .accessibilityAddTraits(.isButton)
                        .accessibilityHint("Open the settings to change the app appearance")
                }
            }
        }
    }
}
