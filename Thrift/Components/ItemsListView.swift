//
//  ItemsListView.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 08/10/25.
//

import SwiftUI
import SwiftData

struct ItemsListView: View {
    @Environment(\.accessibilityReduceMotion) var isReduceMotionEnabled
    @EnvironmentObject private var configModel: Config

    var listTitle: String
    @Binding var editMode: Bool
    @Binding var selectedItemIDs: Set<PersistentIdentifier>

    var filteredItems: [Item]
    @State var selectedItem = Item()
    @State var navigate = false

    @State var itemAngle: Double = 4

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        VStack(spacing: 24) {
            Text(listTitle)
                .sleekText(.large)
                .padding(.top, 24)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredItems, id: \.persistentModelID) { item in
                        ItemTile(
                            item: item,
                            editMode: $editMode,
                            isSelected: selectedItemIDs.contains(item.persistentModelID),
                            onTap: {
                                self.selectedItem = item
                                self.navigate.toggle()
                            },
                            onToggleSelect: {
                                let pid = item.persistentModelID
                                if selectedItemIDs.contains(pid) {
                                    selectedItemIDs.remove(pid)
                                } else {
                                    selectedItemIDs.insert(pid)
                                }
                            }
                        )
                    }
                }
                .padding(16)
            }
        }
        .navigationDestination(isPresented: $navigate) {
            ItemView(item: $selectedItem)
        }
    }
}

private struct ItemTile: View {
    let item: Item
    @Binding var editMode: Bool
    let isSelected: Bool
    let onTap: () -> Void
    let onToggleSelect: () -> Void

    @EnvironmentObject private var configModel: Config

    @State private var wiggleAngle: Double = 0

    private var baseAngle: Double {
        item.persistentModelID.hashValue.isMultiple(of: 2) ? 2.5 : -2.5
    }

    private var staggerDelay: Double {
        Double(abs(item.persistentModelID.hashValue) % 80) / 1000.0
    }

    var body: some View {
        let tile = Image(source: item.getUIImage(), fallbackSystemName: ItemUtils.randomIcon(for: item))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(configModel.textColor)
            .padding()
            .stroke()
            .frame(maxHeight: 200)
            .contentShape(Rectangle())
            .overlay(alignment: .topTrailing) {
                if editMode {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .sleekText(.medium, weight: .bold)
                        .padding(8)
                        .accessibilityHidden(true)
                }
            }
            .opacity(editMode && !isSelected ? 0.6 : 1.0)

        Group {
            if editMode {
                tile.onTapGesture { onToggleSelect() }
            } else {
                tile
                    .onTapGesture { onTap() }
                    .onLongPressGesture(minimumDuration: 0.5) {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                            editMode = true
                        }
                    }
            }
        }
        .accessibilityLabel(Text(item.name.isEmpty ? String(localized: "Default item") : item.name))
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(editMode ? "Tap to select or deselect this item" : "Click here to open this item")
        .rotationEffect(.degrees(wiggleAngle), anchor: .center)
        .onAppear {
            if editMode { startWiggle() }
        }
        .onChange(of: editMode) { _, isEditing in
            if isEditing { startWiggle() } else { stopWiggle() }
        }
    }

    private func startWiggle() {
        wiggleAngle = baseAngle
        withAnimation(
            .easeInOut(duration: 0.18)
                .repeatForever(autoreverses: true)
                .delay(staggerDelay)
        ) {
            wiggleAngle = -baseAngle
        }
    }

    private func stopWiggle() {
        withAnimation(.easeOut(duration: 0.2)) {
            wiggleAngle = 0
        }
    }
}


#Preview {
    HomeView(selectedView: .constant(0))
        .environmentObject(Config())
}
