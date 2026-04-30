//
//  AddItemSheet.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 29/04/26.
//

import SwiftUI

struct AddItemSheet: View {
    @EnvironmentObject private var configModel: Config
    @Environment(\.dismiss) private var dismiss

    var onCustom: () -> Void
    var onCamera: () -> Void
    var onGallery: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Add new item")
                .sleekText(.large)
                .padding(.top, 32)

            HStack(spacing: 16) {
                AddItemOption(
                    icon: "square.and.pencil",
                    text: String(localized: "Custom")
                ) {
                    dismiss()
                    onCustom()
                }

                AddItemOption(
                    icon: "camera.fill",
                    text: String(localized: "Camera")
                ) {
                    dismiss()
                    onCamera()
                }

                AddItemOption(
                    icon: "photo.fill",
                    text: String(localized: "Gallery")
                ) {
                    dismiss()
                    onGallery()
                }
            }
            .frame(maxWidth: .infinity)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .presentationDetents([.height(220)])
        .presentationDragIndicator(.visible)
    }
}

private struct AddItemOption: View {
    @EnvironmentObject private var configModel: Config

    var icon: String
    var text: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .sleekText(.large, weight: .bold)
                    .frame(width: 64, height: 64)
                    .background(configModel.textColor)
                    .clipShape(Circle())
                    .stroke()
                Text(text)
                    .sleekText(.small)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(text)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    Color.gray
        .sheet(isPresented: .constant(true)) {
            AddItemSheet(onCustom: {}, onCamera: {}, onGallery: {})
                .environmentObject(Config())
        }
}
