//
//  CategoriesView.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 09/10/25.
//

import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject private var configModel: Config
    
    @Binding var item: Item
    @Binding var itemEditMode: Bool

    @State var sheetIsPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack (alignment: .center){
                Text("Categories")
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
                }
            }
            
            if item.categories.isEmpty {
                Text("What about organizing this?")
                    .sleekText()
                    .multilineTextAlignment(.leading)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], alignment: .leading, spacing: 12) {
                    ForEach(item.categories, id: \.self) { category in
                        HStack(alignment: .center) {
                            Text(category)
                                .sleekText(disableStroke: true)
                                .lineLimit(1)
                            if itemEditMode {
                                Spacer()
                                Button {
                                    withAnimation {
                                        item.categories.removeAll(where: { $0 == category })
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                        .sleekText(disableStroke: true)
                                }
                            }
                        }
                        .frame(width: 80, height: 24)
                        .editModeStyle()
                    }
                }
            }
        }
        .sheet(isPresented: $sheetIsPresented) {
            CategoriesForm(item: $item)
        }
    }
}

#Preview {
    NavigationStack {
        ItemView(item: .constant(Item.mock))
            .environmentObject(Config())
    }
}
