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
    
    @State private var showFilterSheet: Bool = false
    @State private var filteredCategories: [String] = []
    
    @Query(filter: #Predicate<Item> { $0.isPurchased }, sort: \Item.wasCreated, order: .reverse) var items: [Item]
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if items.isEmpty {
                        Text(String(localized: "You should buy some clothes..."))
                            .sleekText(.medium)
                    } else {
                        let filteredItems = items.filter { item in
                            filteredCategories.allSatisfy { item.categories.contains($0) }
                        }
                        ItemsListView(listTitle: String(localized: "My sleek items:"), editMode: .constant(false), filteredItems: filteredItems)
                    }
                }
                
                HStack {
                    Button {
                        selectedView = 0
                    } label: {
                        EditModeButton(icon: "list.bullet.rectangle.portrait.fill", text: "Wishlist")
                    }
                    .accessibilityLabel("Wishlist")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Click here to return to your wishlist")
                    
                    Spacer()
                }
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 200)
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
            .navigationBarBackButtonHidden()
            .toolbar { ToolbarItems(showFilterSheet: $showFilterSheet) }
            .sheet(isPresented: $showFilterSheet) {
                FilterView(categories: ItemUtils.getCategories(from: items), filteredCategories: $filteredCategories)
            }
        }
    }
}

#Preview {
    PurchasedView(selectedView: .constant(0))
        .environmentObject(Config())
}
