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

    @State var price: String = ""
    @State var priceTagScale = 1.0
    @FocusState private var priceFieldFocused: Bool

    private var currencySymbol: String {
        Locale.current.currencySymbol ?? "R$"
    }

    private static let priceFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.locale = .current
        f.maximumFractionDigits = 2
        return f
    }()

    private func priceString(from value: Double) -> String {
        Self.priceFormatter.string(from: NSNumber(value: value)) ?? ""
    }

    var body: some View {
        VStack(spacing: 0) {
            if !itemEditMode {
                Text(item.price.formatted(.currency(code: Locale.current.currency?.identifier ?? "BRL")))
                    .sleekText(.large, weight: .bold)
                    .padding(.horizontal, 12)
                    .background(configModel.textColor)
                    .clipShape(Capsule())
                    .stroke()
                    .accessibilityLabel("Price")
                    .accessibilityValue(item.price.formatted(.currency(code: Locale.current.currency?.identifier ?? "BRL")))
            } else {
                HStack(spacing: 4) {
                    Text(currencySymbol)
                        .sleekText(.large, weight: .bold)
                        .padding(.leading, 12)
                    TextField("", text: $price)
                        .sleekText(.large, weight: .bold)
                        .tint(configModel.strokeColor)
                        .fixedSize()
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                        .focused($priceFieldFocused)
                        .accessibilityLabel("Price")
                        .accessibilityHint("Type the price for this item")
                        .onChange(of: price) { _, newValue in
                            guard !newValue.isEmpty,
                                  let parsed = Self.priceFormatter.number(from: newValue)?.doubleValue,
                                  parsed < 100_000_000 else { return }
                            item.price = parsed
                        }
                    Button {
                        priceFieldFocused = true
                    } label: {
                        Image(systemName: "pencil")
                            .sleekText(.large, weight: .bold)
                            .padding(.trailing, 4)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Edit price")
                    .accessibilityHint("Open the keyboard to edit the price")
                }
                .padding(.horizontal, 4)
                .background(configModel.textColor)
                .clipShape(Capsule())
                .stroke()
            }
        }
        .scaleEffect(itemEditMode ? 1.0 : priceTagScale)
        .onAppear {
            price = priceString(from: item.price)
            startBreathingIfNeeded()
        }
        .onChange(of: itemEditMode) { _, isEditing in
            if isEditing {
                price = priceString(from: item.price)
                withAnimation(.easeInOut(duration: 0.25)) {
                    priceTagScale = 1.0
                }
            } else {
                startBreathingIfNeeded()
            }
        }
    }

    private func startBreathingIfNeeded() {
        guard !itemEditMode else { return }
        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            priceTagScale = 1.15
        }
    }
}

#Preview {
    NavigationStack {
        ItemView(item: .constant(Item.mock))
            .environmentObject(Config())
    }
}
