//
//  ItemImage.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 10/10/25.
//

import SwiftUI
import PhotosUI

struct ItemImage: View {
    @EnvironmentObject private var configModel: Config
    @Binding var item: Item
    @Binding var itemEditMode: Bool
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var itemAngle: Double = 4
    
    var body: some View {
        Image(source: item.getUIImage(), fallbackSystemName: ItemUtils.randomIcon(for: item))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(configModel.textColor)
            .padding(.horizontal, 32)
            .frame(height: 300)
            .padding(.top, 32)
            .stroke()
            .rotation3DEffect(Angle(degrees: itemEditMode ? 0 : itemAngle), axis: (x: 0, y: 1, z: 1), anchor: .center)
            .onAppear {
                startWobblingIfNeeded()
            }
            .onChange(of: itemEditMode) { _, isEditing in
                if isEditing {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        itemAngle = 0
                    }
                } else {
                    startWobblingIfNeeded()
                }
            }
            .overlay(alignment: .center) {
                if itemEditMode {
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Image(systemName: "plus")
                            .font(.system(size: textSizes.extraLarge.rawValue, weight: .bold))
                            .foregroundStyle(.black)
                            .padding(16)
                            .background(configModel.textColor)
                            .clipShape(Circle())
                            .stroke()
                    }
                    .accessibilityLabel("Change item photo")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Open your photo library to choose a new photo for this item")
                    .task(id: selectedPhoto) {
                        do {
                            guard let data = try await selectedPhoto?.loadTransferable(type: Data.self) else {
                                return
                            }

                            let stickerData = try await StickerCreator.create(from: data)

                            item.updateImageData(stickerData)

                            if item.name.isEmpty,
                               let suggested = await ImageClassifier.suggestedName(from: stickerData) {
                                item.name = suggested
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                PriceTag(item: $item, itemEditMode: $itemEditMode)
                    .rotationEffect(Angle(degrees: itemEditMode ? 0 : -16))
                    .offset(x: -10, y: -40)
            }
    }

    private func startWobblingIfNeeded() {
        guard !itemEditMode else { return }
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            itemAngle = -itemAngle
        }
    }
}

#Preview {
    NavigationStack {
        ItemView(item: .constant(Item.mock))
            .environmentObject(Config())
    }
}
