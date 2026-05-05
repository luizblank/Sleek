//
//  ItemView.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 09/10/25.
//

import SwiftUI

struct ItemView: View {
    @EnvironmentObject private var configModel: Config
    @Environment(\.dismiss) var dismiss
    @Binding var item: Item
    
    @State private var itemEditMode: Bool = false
    @State private var sheetIsPresented: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ItemImage(item: $item, itemEditMode: $itemEditMode)

                VStack(alignment: .leading, spacing: 24) {
                    ItemHeaderView(item: $item, itemEditMode: $itemEditMode)
                    NotesView(item: $item, itemEditMode: $itemEditMode)
                    LinksView(item: $item, itemEditMode: $itemEditMode)
                    CategoriesView(item: $item, itemEditMode: $itemEditMode)
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 32)
        }
        .scrollDismissesKeyboard(.interactively)
        .padding(.horizontal, 6)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(configModel.backgroundColor.ignoresSafeArea())
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $sheetIsPresented) {
            CategoriesForm(item: $item)
        }
        .toolbar {
            if !itemEditMode {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .sleekText(weight: .bold)
                            .frame(width: 36, height: 36)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Close")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Click here to go back")
                }
                .sharedBackgroundVisibility(.hidden)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring(duration: 0.5)) {
                        itemEditMode.toggle()
                        if !itemEditMode {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                } label: {
                    Image(systemName: itemEditMode ? "pencil.slash" : "pencil")
                        .sleekText(weight: .bold)
                        .frame(width: 36, height: 36)
                        .rotationEffect(itemEditMode ? Angle(degrees: 360) : Angle(degrees: 0))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(itemEditMode ? "Stop editing item" : "Edit item")
                .accessibilityAddTraits(.isButton)
                .accessibilityHint(itemEditMode ? "Click here to stop editing this item" : "Click here to edit this item")
            }
            .sharedBackgroundVisibility(.hidden)
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .dismissKeyboardToolbar()
    }
}

#Preview {
    NavigationStack {
        ItemView(item: .constant(Item.mock))
            .environmentObject(Config())
    }
}

