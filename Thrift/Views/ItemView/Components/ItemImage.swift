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
            .rotation3DEffect(Angle(degrees: itemAngle), axis: (x: 0, y: 1, z: 1), anchor: .center)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    itemAngle = -itemAngle
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
                    .task(id: selectedPhoto) {
                        do {
                            guard let data = try await selectedPhoto?.loadTransferable(type: Data.self) else {
                                return
                            }
                            
                            let stickerData = try await StickerCreator.create(from: data)
                            
                            item.updateImageData(stickerData)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                PriceTag(item: $item, itemEditMode: $itemEditMode)
                    .rotationEffect(Angle(degrees: -16))
                    .offset(x: -10, y: -40)
            }
            .id(item.imageData)
    }
}

#Preview {
    NavigationStack {
        ItemView(item: .constant(Item.mock))
            .environmentObject(Config())
    }
}
