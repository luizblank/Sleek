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
    @State private var selectedItemIDs: Set<PersistentIdentifier> = []
    @State private var showDeleteConfirm: Bool = false
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
                        ItemsListView(listTitle: String(localized: "My sleek items:"), editMode: $editMode, selectedItemIDs: $selectedItemIDs, filteredItems: filteredItems)
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
                    Button {
                        moveSelectedToWishlist()
                    } label: {
                        EditModeButton(icon: "list.bullet.rectangle.portrait.fill", text: String(localized: "Wishlist"))
                    }
                    .disabled(selectedItemIDs.isEmpty)
                    .opacity(selectedItemIDs.isEmpty ? 0.5 : 1.0)
                    .accessibilityHidden(!editMode)
                    .accessibilityLabel("Move selected back to wishlist")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Move the selected items back to your wishlist")

                    Spacer()

                    Button {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                            editMode = false
                            selectedItemIDs.removeAll()
                        }
                    } label: {
                        EditModeButton(icon: "xmark", text: String(localized: "Cancel"))
                    }
                    .accessibilityHidden(!editMode)
                    .accessibilityLabel("Close edit mode")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Click here to close edit mode")

                    Spacer()

                    Button {
                        showDeleteConfirm = true
                    } label: {
                        EditModeButton(icon: "trash.fill", text: String(localized: "Delete"))
                    }
                    .disabled(selectedItemIDs.isEmpty)
                    .opacity(selectedItemIDs.isEmpty ? 0.5 : 1.0)
                    .accessibilityHidden(!editMode)
                    .accessibilityLabel("Delete selected")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Delete the selected items from your wardrobe")
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
            .confirmationDialog(
                deleteConfirmTitle,
                isPresented: $showDeleteConfirm,
                titleVisibility: .visible
            ) {
                Button(String(localized: "Delete"), role: .destructive) { deleteSelected() }
                Button(String(localized: "Cancel"), role: .cancel) {}
            } message: {
                Text("This action cannot be undone.")
            }
        }
    }

    private var deleteConfirmTitle: String {
        if selectedItemIDs.count == 1 {
            return String(localized: "Delete this item?")
        }
        return String(localized: "Delete \(selectedItemIDs.count) items?")
    }

    private func moveSelectedToWishlist() {
        for item in items where selectedItemIDs.contains(item.persistentModelID) {
            item.isPurchased = false
        }
        try? modelContext.save()
        withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
            selectedItemIDs.removeAll()
            editMode = false
        }
    }

    private func deleteSelected() {
        for item in items where selectedItemIDs.contains(item.persistentModelID) {
            modelContext.delete(item)
        }
        try? modelContext.save()
        withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
            selectedItemIDs.removeAll()
            editMode = false
        }
    }
}
