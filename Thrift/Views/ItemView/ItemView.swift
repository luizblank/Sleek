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
        VStack(spacing: 16) {
            ItemImage(item: $item, itemEditMode: $itemEditMode)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ItemHeaderView(item: $item, itemEditMode: $itemEditMode)
                    NotesView(item: $item, itemEditMode: $itemEditMode)
                    LinksView(item: $item, itemEditMode: $itemEditMode)
                    CategoriesView(item: $item, itemEditMode: $itemEditMode)
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.horizontal, 6)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(configModel.backgroundColor)
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
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring(duration: 0.5)) {
                        itemEditMode.toggle()
                    }
                } label: {
                    Image(systemName: itemEditMode ? "pencil.slash" : "pencil")
                        .sleekText(weight: .bold)
                        .frame(width: 36, height: 36)
                        .rotationEffect(itemEditMode ? Angle(degrees: 360) : Angle(degrees: 0))
                }
            }
        }
        .dismissKeyboardToolbar()
    }
}

#Preview {
    NavigationStack {
        ItemView(item: .constant(Item.mock))
            .environmentObject(Config())
    }
}

