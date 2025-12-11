//
//  ItemsListView.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 08/10/25.
//

import SwiftUI

struct ItemsListView: View {
    @Environment(\.accessibilityReduceMotion) var isReduceMotionEnabled
    @EnvironmentObject private var configModel: Config
    
    var listTitle: String
    @Binding var editMode: Bool
    
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
                    ForEach(filteredItems, id: \.id) { item in
                        Button {
                            if !editMode {
                                self.navigate.toggle()
                                self.selectedItem = item
                            }
                        } label: {
                            Image(source: item.getUIImage(), fallbackSystemName: ItemUtils.randomIcon(for: item))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(configModel.textColor)
                                .padding()
                                .stroke()
                                .simultaneousGesture(
                                    LongPressGesture(minimumDuration: 0.5)
                                        .onEnded { _ in
                                            withAnimation(.spring(duration: 1)) {
                                                self.editMode = true
                                            }
                                        }
                                )
                                .frame(maxHeight: 200)
                                .draggable(item) {
                                    Image(source: item.getUIImage(), fallbackSystemName: ItemUtils.randomIcon(for: item))
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(configModel.textColor)
                                        .frame(width: 80, height: 80)
                                        .padding()
                                }
                        }
                        .accessibilityLabel(item.name == "" ? String(localized: "Default item") : item.name)
                        .accessibilityAddTraits(.isButton)
                        .accessibilityHint("Click here to open this item")
                        .rotationEffect(Angle(degrees: editMode ? 3 : 0), anchor: .center)
                        .animation(editMode ? .easeInOut(duration: 0.2).repeatForever(autoreverses: true) : .default, value: editMode)
                        .id(item.imageData)
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


#Preview {
    HomeView(selectedView: .constant(0))
        .environmentObject(Config())
}
