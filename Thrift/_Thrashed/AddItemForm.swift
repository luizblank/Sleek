//
//  AddItemForm.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 10/10/25.
//

import SwiftUI
import PhotosUI
import StoreKit

struct AddItemForm: View {
    @EnvironmentObject var configModel: Config
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Environment(\.requestReview) var requestReview
    
    @State var item = Item()
    
    @State var price: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Subtitle("Add new item")
                .padding(.top, 32)
                .padding(.bottom, 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Name")
                    .font(.customFont(name: configModel.font, size: 18))
                    .foregroundStyle(.white)
                    .stroke()
                TextField("", text: $item.name, prompt: Text("Item name goes here...").foregroundStyle(.black.opacity(0.7)))
                    .formStyle(configModel)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Price")
                    .font(.customFont(name: configModel.font, size: 18))
                    .foregroundStyle(.white)
                    .stroke()
                TextField("", text: $price, prompt: Text("This item costs a lot...").foregroundStyle(.black.opacity(0.7)))
                    .formStyle(configModel)
                    .keyboardType(.decimalPad)
                    .onChange(of: price) { oldValue, newValue in
                        item.price = Double(newValue.replacingOccurrences(of: ",", with: ".")) ?? 0
                    }
            }
            
            HStack {
                Spacer()
                Button {
                    if item.name.isEmpty || item.price == 0  || item.price > 100_000_000 { return }
                    modelContext.insert(item)
                    requestReview()
                    dismiss()
                } label: {
                    Text("Add")
                        .foregroundStyle(.white)
                        .font(.customFont(name: configModel.font, size: 20, weight: .bold))
                        .stroke()
                        .padding(.vertical, 4)
                        .padding(.horizontal, 16)
                        .frame(width: 80)
                        .background(.white)
                        .clipShape(Capsule())
                        .stroke()
                }
            }
        }
        .padding()
        .presentationDetents([.fraction(0.5)])
        .presentationDragIndicator(.visible)
        .dismissKeyboardToolbar()
    }
}



#Preview {
    AddItemForm()
}
