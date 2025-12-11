//
//  PriceTag.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 09/10/25.
//

import SwiftUI

struct PriceTag: View {
    @EnvironmentObject private var configModel: Config
    @Binding var item: Item
    @Binding var itemEditMode: Bool
    
    @State var lastPrice: Double = 0.0
    @State var price: String = ""
    @State var priceTagScale = 1.0
    
    var body: some View {
        VStack(spacing: 0) {
            if !itemEditMode {
                Text(item.price.formatted(.currency(code: Locale.current.currency?.identifier ?? "BRL")))
                    .sleekText(.large, weight: .bold)
                    .padding(.horizontal, 12)
                    .background(configModel.textColor)
                    .clipShape(Capsule())
                    .stroke()
            } else {
                HStack(spacing: 4) {
                    TextField("", text: $price)
                        .sleekText(.large, weight: .bold)
                        .padding(.leading, 12)
                        .fixedSize()
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                        .onChange(of: price) { _, newValue in
                            guard Decimal(string: newValue) != nil && !newValue.isEmpty else { return }
                            
                            let formattedPrice = Decimal(string: newValue) ?? Decimal(lastPrice)
                            if formattedPrice < 100_000_000 {
                                item.price = Double(newValue.replacingOccurrences(of: ",", with: ".")) ?? lastPrice
                            } else {
                                item.price = lastPrice
                            }
                        }
                    Image(systemName: "pencil")
                        .sleekText(.large)
                }
                .padding(.horizontal, 4)
                .background(configModel.textColor)
                .clipShape(Capsule())
                .stroke()
            }
        }
        .scaleEffect(priceTagScale)
        .onAppear {
            lastPrice = item.price
            price = "\(item.price.formatted())"
            
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                priceTagScale = 1.15
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
