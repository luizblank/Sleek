//
//  CategoriesForm.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 09/10/25.
//

import SwiftUI

struct CategoriesForm: View {
    @EnvironmentObject private var configModel: Config
    
    @Binding var item: Item
    @State var categoriesEditMode: Bool = false
    
    @State var newCategory: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add categories")
                .sleekText(.medium)
                .padding(.top, 32)
                .padding(.bottom, 12)
            
            HStack {
                TextField("", text: $newCategory, prompt: Text("Add a category...").foregroundStyle(.black.opacity(0.7)))
                    .padding(.horizontal)
                    .font(.customFont(name: configModel.font, size: textSizes.normal.rawValue))
                    .onSubmit {
                        if newCategory.isEmpty { return }
                        withAnimation {
                            item.categories.append(newCategory)
                        }
                        newCategory = ""
                    }
                
                Button {
                    if newCategory.isEmpty || item.categories.contains(newCategory) { return }
                    withAnimation {
                        item.categories.append(newCategory.lowercased())
                    }
                    newCategory = ""
                } label: {
                    Image(systemName: "plus") // criar componente
                        .sleekText(weight: .bold)
                        .frame(width: 40, height: 40)
                        .background(configModel.textColor)
                        .clipShape(Capsule())
                        .stroke()
                }
            }
            .padding(6)
            .background(.black.opacity(0.05))
            .clipShape(Capsule())
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                    ForEach(item.categories, id: \.self) { category in
                        Text(category)
                            .font(.customFont(name: configModel.font, size: 20))
                            .foregroundStyle(.black)
                            .lineLimit(1)
                            .frame(width: 80, height: 24)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(configModel.textColor)
                            .clipShape(Capsule())
                            .stroke()
                    }
                }
            }
        }
        .padding()
        .presentationDetents([.fraction(0.5)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    CategoriesForm(item: .constant(Item.mock))
        .environmentObject(Config())
}
