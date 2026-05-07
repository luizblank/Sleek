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
    @State private var editSnapshot: ItemSnapshot?

    var startInEditMode: Bool = false

    private struct ItemSnapshot {
        var name: String
        var desc: String
        var price: Double
        var links: [String]
        var categories: [String]
    }

    private func captureSnapshot() {
        editSnapshot = ItemSnapshot(
            name: item.name,
            desc: item.desc,
            price: item.price,
            links: item.links,
            categories: item.categories
        )
    }

    private func revertSnapshot() {
        guard let snap = editSnapshot else { return }
        item.name = snap.name
        item.desc = snap.desc
        item.price = snap.price
        item.links = snap.links
        item.categories = snap.categories
    }

    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
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
        .onAppear {
            if startInEditMode && !itemEditMode {
                captureSnapshot()
                itemEditMode = true
            }
        }
        .sheet(isPresented: $sheetIsPresented) {
            CategoriesForm(item: $item)
        }
        .toolbar {
            if #available(iOS 26.0, *) {
                ToolbarItem(placement: .topBarLeading) {
                    if itemEditMode {
                        Button {
                            endEditing()
                            revertSnapshot()
                            withAnimation(.spring(duration: 0.5)) {
                                itemEditMode = false
                            }
                        } label: {
                            Text("Cancel")
                                .sleekText(weight: .bold)
                                .fixedSize()
                                .padding(.horizontal, 12)
                                .frame(height: 36)
                                .background(configModel.textColor)
                                .clipShape(Capsule())
                                .stroke()
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Cancel editing")
                        .accessibilityAddTraits(.isButton)
                        .accessibilityHint("Discard changes and stop editing this item")
                    } else {
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
                }
                .sharedBackgroundVisibility(.hidden)
            } else {
                ToolbarItem(placement: .topBarLeading) {
                    if itemEditMode {
                        Button {
                            endEditing()
                            revertSnapshot()
                            withAnimation(.spring(duration: 0.5)) {
                                itemEditMode = false
                            }
                        } label: {
                            Text("Cancel")
                                .sleekText(weight: .bold)
                                .fixedSize()
                                .padding(.horizontal, 12)
                                .frame(height: 36)
                                .background(configModel.textColor)
                                .clipShape(Capsule())
                                .stroke()
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Cancel editing")
                        .accessibilityAddTraits(.isButton)
                        .accessibilityHint("Discard changes and stop editing this item")
                    } else {
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
                }
            }

            if #available(iOS 26.0, *) {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring(duration: 0.5)) {
                            if itemEditMode {
                                endEditing()
                                itemEditMode = false
                                editSnapshot = nil
                            } else {
                                captureSnapshot()
                                itemEditMode = true
                            }
                        }
                    } label: {
                        if itemEditMode {
                            Text("OK")
                                .sleekText(weight: .bold)
                                .fixedSize()
                                .padding(.horizontal, 16)
                                .frame(height: 36)
                                .background(configModel.textColor)
                                .clipShape(Capsule())
                                .stroke()
                        } else {
                            Image(systemName: "pencil")
                                .sleekText(weight: .bold)
                                .frame(width: 36, height: 36)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(itemEditMode ? "Confirm edits" : "Edit item")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint(itemEditMode ? "Save changes and stop editing this item" : "Click here to edit this item")
                }
                .sharedBackgroundVisibility(.hidden)
            } else {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring(duration: 0.5)) {
                            if itemEditMode {
                                endEditing()
                                itemEditMode = false
                                editSnapshot = nil
                            } else {
                                captureSnapshot()
                                itemEditMode = true
                            }
                        }
                    } label: {
                        if itemEditMode {
                            Text("OK")
                                .sleekText(weight: .bold)
                                .fixedSize()
                                .padding(.horizontal, 16)
                                .frame(height: 36)
                                .background(configModel.textColor)
                                .clipShape(Capsule())
                                .stroke()
                        } else {
                            Image(systemName: "pencil")
                                .sleekText(weight: .bold)
                                .frame(width: 36, height: 36)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(itemEditMode ? "Confirm edits" : "Edit item")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint(itemEditMode ? "Save changes and stop editing this item" : "Click here to edit this item")
                }
            }
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

