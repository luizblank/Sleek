//
//  PurchasedView.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 15/10/25.
//

import SwiftUI
import SwiftData

struct PurchasedView: View {
    @EnvironmentObject private var configModel: Config
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @Binding var selectedView: Int

    @State private var editMode: Bool = false
    @State private var wishlistTargeted: Bool = false
    @State private var trashTargeted: Bool = false
    @State private var showFilterSheet: Bool = false
    @State private var filteredCategories: [String] = []
    @State private var containerSize: CGSize = .zero

    @Query(
        filter: #Predicate<Item> { $0.isPurchased },
        sort: [SortDescriptor(\Item.wasCreated, order: .reverse)]
    ) var items: [Item]

    private var sortedItems: [Item] {
        items.sorted { $0.isFavorite && !$1.isFavorite }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if sortedItems.isEmpty {
                        Text("You should buy some clothes...")
                            .sleekText(.medium)
                    } else {
                        let filteredItems = sortedItems.filter { item in
                            filteredCategories.allSatisfy { item.categories.contains($0) }
                        }
                        ItemsListView(listTitle: String(localized: "My sleek items:"), editMode: $editMode, filteredItems: filteredItems)
                    }
                }

                HStack {
                    Button {
                        selectedView = 0
                    } label: {
                        EditModeButton(icon: "list.bullet.rectangle.portrait.fill", text: String(localized: "Wishlist"))
                    }
                    .accessibilityHidden(editMode)
                    .accessibilityLabel("Wishlist")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Click here to return to your wishlist")

                    Spacer()
                }
                .position(x: containerSize.width / 2, y: containerSize.height - 100)
                .offset(y: editMode ? 300 : 0)

                HStack {
                    EditModeButton(icon: "list.bullet.rectangle.portrait.fill", text: String(localized: "Wishlist"))
                        .accessibilityElement(children: .ignore)
                        .accessibilityHidden(!editMode)
                        .accessibilityLabel("Drop location to move items back to wishlist")
                        .accessibilityHint("Drop an item here to move it back to your wishlist")
                        .scaleEffect(wishlistTargeted ? 1.2 : 1.0)
                        .dropDestination(for: ItemTransfer.self) { droppedItems, location in
                            guard let droppedItem = droppedItems.first else { return false }

                            if let index = items.firstIndex(where: { $0.id == droppedItem.id }) {
                                items[index].isPurchased = false
                            }

                            return true
                        } isTargeted: { isTargeted in
                            withAnimation(.spring) {
                                wishlistTargeted = isTargeted
                            }
                        }

                    Spacer()

                    Button {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                            editMode = false
                        }
                    } label: {
                        EditModeButton(icon: "xmark", text: String(localized: "Cancel"))
                    }
                    .accessibilityHidden(!editMode)
                    .accessibilityLabel("Close edit mode")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Click here to close edit mode")

                    Spacer()

                    EditModeButton(icon: "trash.fill", text: String(localized: "Delete"))
                        .accessibilityElement(children: .ignore)
                        .accessibilityHidden(!editMode)
                        .accessibilityLabel("Drop location to delete items")
                        .accessibilityHint("Drop an item here to delete it from your wardrobe")
                        .scaleEffect(trashTargeted ? 1.2 : 1.0)
                        .dropDestination(for: ItemTransfer.self) { droppedItems, location in
                            guard let droppedItem = droppedItems.first else { return false }

                            if let index = items.firstIndex(where: { $0.id == droppedItem.id }) {
                                modelContext.delete(items[index])
                            }

                            do {
                                try modelContext.save()
                            } catch {
                                print("Error saving context after deletion: \(error)")
                            }

                            return true
                        } isTargeted: { isTargeted in
                            withAnimation(.spring) {
                                trashTargeted = isTargeted
                            }
                        }
                }
                .position(x: containerSize.width / 2, y: containerSize.height - 100)
                .offset(y: editMode ? 0 : 300)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                if let bgImage = configModel.backgroundImage {
                    Image(uiImage: bgImage)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                } else {
                    configModel.backgroundColor
                        .ignoresSafeArea()
                }
            }
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newSize in
                containerSize = newSize
            }
            .navigationBarBackButtonHidden()
            .toolbar { ToolbarItems(showFilterSheet: $showFilterSheet) }
            .toolbarBackground(.hidden, for: .navigationBar)
            .sheet(isPresented: $showFilterSheet) {
                FilterView(categories: ItemUtils.getCategories(from: items), filteredCategories: $filteredCategories)
            }
        }
    }
}
