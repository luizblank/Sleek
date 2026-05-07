//
//  Configuration.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 02/12/25.
//

import SwiftUI
import SwiftData

struct ConfigView: View {
    @EnvironmentObject private var configModel: Config
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    @Query private var allItems: [Item]
    
    @State private var rotate1: Double = 0
    @State private var rotate2: Double = 0
    @State private var showResetItemsAlert: Bool = false
    
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
                        
                        ResetButton(String(localized: "Reset onboarding")) {
                            hasSeenOnboarding = false
                            dismiss()
                        }
                        .accessibilityLabel("Reset onboarding button")
                        .accessibilityAddTraits(.isButton)
                        .accessibilityHint("Click here to see the welcome tour again")
                        
                        ResetButton(String(localized: "Reset customizations")) {
                            configModel.backgroundColor = Color(hex: "#e55381")
                            UserDefaults.standard.set("#e55381", forKey: "backgroundColor")
                            
                            configModel.backgroundImage = nil
                            UserDefaults.standard.removeObject(forKey: "backgroundImage")
                            
                            configModel.strokeColor = Color(hex: "#000000")
                            UserDefaults.standard.set("#000000", forKey: "strokeColor")
                            
                            configModel.textColor = Color(hex: "#ffffff")
                            UserDefaults.standard.set("#ffffff", forKey: "textColor")
                            
                            configModel.logo = "horizontalLogo"
                            UserDefaults.standard.set("horizontalLogo", forKey: "logo")
                            
                            configModel.font = "Antonio"
                            UserDefaults.standard.set("Antonio", forKey: "font")
                        }
                        .accessibilityLabel("Reset customizations button")
                        .accessibilityAddTraits(.isButton)
                        .accessibilityHint("Click here to reset colors, font, and background to their default values")
                        
                        ResetButton(String(localized: "Reset all items")) {
                            showResetItemsAlert = true
                        }
                        .accessibilityLabel("Reset all items button")
                        .accessibilityAddTraits(.isButton)
                        .accessibilityHint("Click here to delete every item in your wishlist and wardrobe")
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(.sleekPink)
            .navigationBarBackButtonHidden(true)
            .alert(String(localized: "Reset all items?"), isPresented: $showResetItemsAlert) {
                Button(String(localized: "Cancel"), role: .cancel) { }
                Button(String(localized: "Reset"), role: .destructive) {
                    for item in allItems {
                        modelContext.delete(item)
                    }
                    try? modelContext.save()
                }
            } message: {
                Text("This will permanently delete every item in your wishlist and wardrobe. This can't be undone.")
            }
            .toolbar {
                if #available(iOS 26.0, *) {
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
                        .buttonStyle(.plain)
                    }
                    .sharedBackgroundVisibility(.hidden)
                } else {
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
                        .buttonStyle(.plain)
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ConfigView()
        .environmentObject(Config())
}
