//
//  ContentView.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 07/10/25.
//

import SwiftUI
import SwiftData
import StoreKit

struct HomeView: View {
    @EnvironmentObject private var configModel: Config
    @Environment(\.modelContext) var modelContext
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.requestReview) var requestReview
    
    @Binding var selectedView: Int
    
    @State private var editMode: Bool = false
    @State private var purchasedTargeted: Bool = false
    @State private var trashTargeted: Bool = false
    @State private var showFilterSheet: Bool = false
    @State private var filteredCategories: [String] = []
    
    @Query(filter: #Predicate<Item> { !$0.isPurchased }, sort: \Item.wasCreated, order: .reverse) var items: [Item]
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if items.isEmpty {
                        Text("What items do you want?")
                            .sleekText(.medium)
                    } else {
                        let filteredItems = items.filter { item in
                            filteredCategories.allSatisfy { item.categories.contains($0) }
                        }
                        ItemsListView(listTitle: String(localized: "I want to buy:"), editMode: $editMode, filteredItems: filteredItems)
                    }
                }
                
                HStack {
                    Button {
                        selectedView = 1
                    } label: {
                        EditModeButton(icon: "cabinet.fill", text: String(localized: "Wardrobe"))
                    }
                    .accessibilityHidden(editMode)
                    .accessibilityLabel("Your wardrobe")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Click here to open your wardrobe and see all the items you already bought")
                    
                    Spacer()
                    Button {
                        modelContext.insert(Item())
                        
                        let itemsCount = items.count + 1
                        if itemsCount == 3 || itemsCount == 10 || itemsCount == 20 {
                            requestReview()
                        }
                    } label: {
                        EditModeButton(icon: "plus", text: String(localized: "Add item"))
                    }
                    .accessibilityHidden(editMode)
                    .accessibilityLabel("New item")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Click here to add a new item to your wishlist")
                }
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 200)
                .offset(y: editMode ? 300 : 0)
                
                HStack {
                    EditModeButton(icon: "basket.fill", text: String(localized: "Purchased"))
                        .accessibilityElement(children: .ignore)
                        .accessibilityHidden(!editMode)
                        .accessibilityLabel("Drop location for purchased items")
                        .accessibilityHint("Drop an item here to add it to your wardrobe")
                        .scaleEffect(purchasedTargeted ? 1.2 : 1.0)
                        .dropDestination(for: Item.self) { droppedItems, location in
                            guard let droppedItem = droppedItems.first else { return false }
                            
                            if let index = items.firstIndex(where: { $0.id == droppedItem.id }) {
                                items[index].isPurchased = true
                            }
                            
                            return true
                        } isTargeted: { isTargeted in
                            withAnimation(.spring) {
                                purchasedTargeted = isTargeted
                            }
                        }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring(duration: 1)) {
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
                        .accessibilityHint("Drop an item here to delete it from your wishlist")
                        .scaleEffect(trashTargeted ? 1.2 : 1.0)
                        .dropDestination(for: Item.self) { droppedItems, location in
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
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 200)
                .offset(y: editMode ? 0 : 300)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Background())
            .toolbar { ToolbarItems(showFilterSheet: $showFilterSheet) }
            .sheet(isPresented: $showFilterSheet) {
                FilterView(categories: ItemUtils.getCategories(from: items), filteredCategories: $filteredCategories)
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    checkForImportedImage()
                }
            }
            .onAppear {
                checkForImportedImage()
            }
        }
    }
    
    func checkForImportedImage() {
        guard let sharedDefaults = UserDefaults(suiteName: "group.luiz.dev.sleek"),
            sharedDefaults.bool(forKey: "has_new_shared_image")
        else { return }
        
        sharedDefaults.set(false, forKey: "has_new_shared_image")
        
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.luiz.dev.sleek")
        else { return }

        let fileURL = containerURL.appendingPathComponent("shared_screenshot.data")

        Task {
            do {
                let rawData = try Data(contentsOf: fileURL)
                let stickerData = try await StickerCreator.create(from: rawData)

                try await MainActor.run {
                    let item = Item(
                        imageData: stickerData
                    )
                    
                    modelContext.insert(item)
                    try modelContext.save()
                }

                try FileManager.default.removeItem(at: fileURL)

            } catch {
                print("Error importing image: \(error)")
            }
        }
    }
}

#Preview {
    HomeView(selectedView: .constant(0))
        .environmentObject(Config())
}
