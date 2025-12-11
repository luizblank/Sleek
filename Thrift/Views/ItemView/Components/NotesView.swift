//
//  ExtractedView.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 09/10/25.
//

import SwiftUI

struct NotesView: View {
    @EnvironmentObject private var configModel: Config
    @Binding var item: Item
    @Binding var itemEditMode: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Notes")
                .sleekText(.medium)
            if !itemEditMode {
                Text(item.desc.isEmpty ? String(localized: "Description missing here!") : item.desc)
                    .sleekText()
            } else {
                TextField("", text: $item.desc, prompt: Text("You can add a note here...").foregroundStyle(configModel.textColor.opacity(0.7)), axis: .vertical)
                    .sleekText(disableStroke: true)
                    .editModeStyle()
                    .frame(minHeight: 50)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ItemView(item: .constant(Item()))
            .environmentObject(Config())
    }
}
