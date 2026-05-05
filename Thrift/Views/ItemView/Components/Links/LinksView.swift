//
//  LinksView.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 13/10/25.
//

import SwiftUI

struct LinksView: View {
    @EnvironmentObject private var configModel: Config
    @Environment(\.openURL) var openURL
    
    @Binding var item: Item
    @Binding var itemEditMode: Bool
    
    @State var sheetIsPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack (alignment: .center){
                Text("Links")
                    .sleekText(.medium)
                Spacer()
                if itemEditMode {
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .sleekText(.medium, weight: .bold)
                            .frame(width: 40, height: 40)
                    }
                    .accessibilityLabel("Add links")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Open the form to add new links")
                }
            }
            
            VStack(alignment: .leading) {
                if item.links.isEmpty {
                    Text("Where can you find this item?")
                        .sleekText()
                        .multilineTextAlignment(.leading)
                } else {
                    ForEach(item.links, id: \.self) { link in
                        Button {
                            if let url = URL(string: link),
                               !itemEditMode {
                                openURL(url)
                            }
                        } label: {
                            HStack {
                                Text(link)
                                    .sleekText(disableStroke: true)
                                    .lineLimit(1)
                                Spacer()
                                if itemEditMode {
                                    Button {
                                        withAnimation {
                                            item.links.removeAll(where: { $0 == link })
                                        }
                                    } label: {
                                        Image(systemName: "xmark")
                                            .sleekText(disableStroke: true)
                                    }
                                    .accessibilityLabel(String(localized: "Remove link"))
                                    .accessibilityValue(link)
                                    .accessibilityAddTraits(.isButton)
                                    .accessibilityHint("Remove this link from the item")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .editModeStyle()
                        }
                        .accessibilityLabel(link)
                        .accessibilityAddTraits(.isLink)
                        .accessibilityHint(itemEditMode ? "Tap the X to remove this link" : "Open this link in your browser")
                    }
                }
            }
        }
        .sheet(isPresented: $sheetIsPresented) {
            LinksForm(item: $item)
        }
    }
}

#Preview {
    NavigationStack {
        ItemView(item: .constant(Item.mock))
            .environmentObject(Config())
    }
}
