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
        if #available(iOS 26.0, *) {
            ToolbarItem(placement: .topBarLeading) {
                LogoView()
                    .frame(height: 46)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .sharedBackgroundVisibility(.hidden)
        } else {
            ToolbarItem(placement: .topBarLeading) {
                LogoView()
                    .frame(height: 46)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        
        if #available(iOS 26.0, *) {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        showFilterSheet.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .sleekText(.medium)
                            .frame(width: 36, height: 36)
                            .accessibilityLabel("Filter")
                            .accessibilityAddTraits(.isButton)
                            .accessibilityHint("Open the filter to select the registered categories")
                    }
                    .buttonStyle(.plain)
                    
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
                    .buttonStyle(.plain)
                }
            }
            .sharedBackgroundVisibility(.hidden)
        } else {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        showFilterSheet.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .sleekText(.medium)
                            .frame(width: 36, height: 36)
                            .accessibilityLabel("Filter")
                            .accessibilityAddTraits(.isButton)
                            .accessibilityHint("Open the filter to select the registered categories")
                    }
                    .buttonStyle(.plain)
                    
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
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
