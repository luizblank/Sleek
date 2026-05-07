//
//  ContentView.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 07/10/25.
//

import SwiftUI
import SwiftData
import StoreKit
import PhotosUI

struct HomeView: View {
    @EnvironmentObject private var configModel: Config
    @Environment(\.modelContext) var modelContext
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.requestReview) var requestReview

    @Binding var selectedView: Int

    @State private var editMode: Bool = false
    @State private var selectedItemIDs: Set<PersistentIdentifier> = []
    @State private var showDeleteConfirm: Bool = false
    @State private var showFilterSheet: Bool = false
    @State private var filteredCategories: [String] = []
    @State private var showAddDialog: Bool = false
    @State private var showCamera: Bool = false
    @State private var showPhotoPicker: Bool = false
    @State private var pickedPhotos: [PhotosPickerItem] = []
    @State private var containerSize: CGSize = .zero
    @State private var newlyCreatedItem: Item?

    @Query(
        filter: #Predicate<Item> { !$0.isPurchased },
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
                        Text("What items do you want?")
                            .sleekText(.medium)
                    } else {
                        let filteredItems = sortedItems.filter { item in
                            filteredCategories.allSatisfy { item.categories.contains($0) }
                        }
                        ItemsListView(listTitle: String(localized: "I want to buy:"), editMode: $editMode, selectedItemIDs: $selectedItemIDs, filteredItems: filteredItems)
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
                        showAddDialog = true
                    } label: {
                        EditModeButton(icon: "plus", text: String(localized: "Add item"))
                    }
                    .accessibilityHidden(editMode)
                    .accessibilityLabel("New item")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Click here to add a new item to your wishlist")
                }
                .position(x: containerSize.width / 2, y: containerSize.height - 100)
                .offset(y: editMode ? 300 : 0)
                
                HStack {
                    Button {
                        markSelectedAsPurchased()
                    } label: {
                        EditModeButton(icon: "basket.fill", text: String(localized: "Purchased"))
                    }
                    .disabled(selectedItemIDs.isEmpty)
                    .opacity(selectedItemIDs.isEmpty ? 0.5 : 1.0)
                    .accessibilityHidden(!editMode)
                    .accessibilityLabel("Mark selected as purchased")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Move the selected items to your wardrobe")

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
                    .accessibilityHint("Delete the selected items from your wishlist")
                }
                .position(x: containerSize.width / 2, y: containerSize.height - 100)
                .offset(y: editMode ? 0 : 300)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Background())
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newSize in
                containerSize = newSize
            }
            .toolbar { ToolbarItems(showFilterSheet: $showFilterSheet) }
            .toolbarBackground(.hidden, for: .navigationBar)
            .sheet(isPresented: $showFilterSheet) {
                FilterView(categories: ItemUtils.getCategories(from: items), filteredCategories: $filteredCategories)
            }
            .alert(
                deleteConfirmTitle,
                isPresented: $showDeleteConfirm
            ) {
                Button(String(localized: "Cancel"), role: .cancel) {}
                Button(String(localized: "Delete"), role: .destructive) { deleteSelected() }
            } message: {
                Text("This action cannot be undone.")
            }
            .sheet(isPresented: $showAddDialog) {
                AddItemSheet(
                    onCustom: { addCustomItem() },
                    onCamera: { showCamera = true },
                    onGallery: { showPhotoPicker = true }
                )
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraPicker { data in
                    Task { await addItem(from: data) }
                }
                .ignoresSafeArea()
            }
            .photosPicker(
                isPresented: $showPhotoPicker,
                selection: $pickedPhotos,
                maxSelectionCount: 0,
                matching: .images
            )
            .onChange(of: pickedPhotos) { _, newItems in
                guard !newItems.isEmpty else { return }
                let items = newItems
                pickedPhotos = []
                Task { await loadAndAddPickedPhotos(items) }
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    checkForImportedImage()
                }
            }
            .onAppear {
                checkForImportedImage()
            }
            .navigationDestination(item: $newlyCreatedItem) { item in
                ItemView(item: .constant(item), startInEditMode: true)
            }
        }
    }

    private var deleteConfirmTitle: String {
        if selectedItemIDs.count == 1 {
            return String(localized: "Delete this item?")
        }
        return String(localized: "Delete \(selectedItemIDs.count) items?")
    }

    private func markSelectedAsPurchased() {
        for item in items where selectedItemIDs.contains(item.persistentModelID) {
            item.isPurchased = true
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

    private func addCustomItem() {
        let item = Item()
        item.name = ItemUtils.defaultName(for: item)
        modelContext.insert(item)
        bumpReviewIfNeeded()
        newlyCreatedItem = item
    }

    private func bumpReviewIfNeeded() {
        let itemsCount = items.count + 1
        if itemsCount == 3 || itemsCount == 10 || itemsCount == 20 {
            requestReview()
        }
    }

    private func addItem(from data: Data) async {
        let stickerData: Data
        do {
            stickerData = try await StickerCreator.create(from: data)
        } catch {
            stickerData = data
        }

        let suggestedName = await ImageClassifier.suggestedName(from: stickerData)

        await MainActor.run {
            let item = Item(
                imageData: stickerData,
                name: suggestedName ?? ""
            )
            modelContext.insert(item)
            try? modelContext.save()
            bumpReviewIfNeeded()
            newlyCreatedItem = item
        }
    }

    private func loadAndAddPickedPhotos(_ items: [PhotosPickerItem]) async {
        for picked in items {
            guard let data = try? await picked.loadTransferable(type: Data.self) else { continue }
            await addItem(from: data)
        }
    }
    
    func checkForImportedImage() {
        guard let sharedDefaults = UserDefaults(suiteName: "group.luiz.dev.sleek"),
              sharedDefaults.bool(forKey: "has_new_shared_image")
        else { return }

        sharedDefaults.set(false, forKey: "has_new_shared_image")

        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.luiz.dev.sleek")
        else { return }

        let count = max(sharedDefaults.integer(forKey: "shared_image_count"), 0)
        sharedDefaults.set(0, forKey: "shared_image_count")

        var fileURLs: [URL] = []
        if count > 0 {
            for index in 0..<count {
                fileURLs.append(containerURL.appendingPathComponent("shared_screenshot_\(index).data"))
            }
        } else {
            // Backwards compatibility: legacy single-file path
            let legacy = containerURL.appendingPathComponent("shared_screenshot.data")
            if FileManager.default.fileExists(atPath: legacy.path) {
                fileURLs.append(legacy)
            }
        }

        guard !fileURLs.isEmpty else { return }

        Task {
            for fileURL in fileURLs {
                guard let rawData = try? Data(contentsOf: fileURL) else { continue }
                await addItem(from: rawData)
                try? FileManager.default.removeItem(at: fileURL)
            }
        }
    }
}

#Preview {
    HomeView(selectedView: .constant(0))
        .environmentObject(Config())
}
