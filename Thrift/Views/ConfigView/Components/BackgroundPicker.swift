//
//  BackgroundPicker.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 05/12/25.
//

import SwiftUI
import PhotosUI

struct BackgroundPicker: View {
    @EnvironmentObject var configModel: Config
    @State private var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        ZStack {
            Image(uiImage: configModel.backgroundImage ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 120)
                .overlay(
                    Rectangle()
                        .stroke(
                            Color.white,
                            style: StrokeStyle(lineWidth: 3, dash: [10, 5])
                        )
                )
                .accessibilityHidden(true)
            
            if configModel.backgroundImage != nil {
                Button {
                    configModel.backgroundImage = nil
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.black)
                        .padding(8)
                        .background(.white)
                        .clipShape(Circle())
                        .stroke(.black)
                }
                .onChange(of: configModel.backgroundImage) { _, newValue in
                    UserDefaults.standard.set(newValue, forKey: "backgroundImage")
                }
                .accessibilityLabel("Remove background image")
                .accessibilityAddTraits(.isButton)
                .accessibilityHint("Click here to remove the current background image")
                .accessibilityValue(configModel.backgroundImage != nil ? String(localized: "Selected image") : String(localized: "None"))
                
            } else {
                PhotosPicker(
                    selection: $selectedPhoto,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.black)
                        .padding(8)
                        .background(.white)
                        .clipShape(Circle())
                        .stroke(.black)
                }
                .task(id: selectedPhoto) {
                    do {
                        guard let data = try await selectedPhoto?.loadTransferable(type: Data.self) else {
                            return
                        }
                        
                        UserDefaults.standard.set(data, forKey: "backgroundImage")
                        configModel.backgroundImage = UIImage(data: data)!
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                .accessibilityLabel("Add background image")
                .accessibilityAddTraits(.isButton)
                .accessibilityHint("Click here to select an image to use as the background")
                .accessibilityValue(configModel.backgroundImage != nil ? String(localized: "Selected image") : String(localized: "None"))
            }
        }
        .padding(.leading, 4)
    }
}

#Preview {
    BackgroundPicker()
        .environmentObject(Config())
}
