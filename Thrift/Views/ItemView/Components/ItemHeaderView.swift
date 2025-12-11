//
//  ItemHeader.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 09/10/25.
//

import SwiftUI

struct ItemHeaderView: View {
    @EnvironmentObject private var configModel: Config
    @Binding var item: Item
    @Binding var itemEditMode: Bool
    
    var body: some View {
        HStack {
            if !itemEditMode {
                Text(item.name.isEmpty ? String(localized: "What is your item's name?") : item.name)
                    .sleekText(.large)
            } else {
                VStack(alignment: .leading) {
                    Text("Name")
                        .sleekText(.medium)
                    TextField(
                        "",
                        text: $item.name,
                        prompt: Text("What was that item's name?")
                            .foregroundStyle(configModel.textColor.opacity(0.7)),
                        axis: .vertical
                    )
                    .sleekText(disableStroke: true)
                    .lineLimit(1)
                    .editModeStyle()
                }
            }
            Spacer()
            if !itemEditMode {
                Button {
                    withAnimation(.spring(duration: 0.5)) {
                        item.isFavorite.toggle()
                    }
                } label: {
                    Image(systemName: item.isFavorite ? "star.fill" :"star.slash.fill")
                        .sleekText(.large, weight: .bold)
                        .rotationEffect(item.isFavorite ? Angle(degrees: 360) : Angle(degrees: 0))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ItemView(item: .constant(Item.mock))
            .environmentObject(Config())
    }
}
