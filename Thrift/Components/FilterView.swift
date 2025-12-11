//
//  FilterView.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 13/10/25.
//

import SwiftUI

struct FilterView: View {
    @EnvironmentObject private var configModel: Config
    
    var categories: [String]
    @Binding var filteredCategories: [String]
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Filter your items")
                .sleekText(.large)
                .padding(.top, 32)
                .padding(.bottom, 12)
            
            if categories.isEmpty {
                Text("Nothing to filter yet")
                    .sleekText()
            } else {
                Text("Categories")
                    .sleekText(.medium)
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .leading) {
                        ForEach(categories, id: \.self) { category in
                            Button {
                                if filteredCategories.contains(category) {
                                    filteredCategories.removeAll { $0 == category }
                                } else {
                                    filteredCategories.append(category)
                                }
                            } label: {
                                HStack(spacing: 0) {
                                    Image(systemName: filteredCategories.contains(category) ? "checkmark.square" : "square")
                                        .font(.system(size: textSizes.medium.rawValue, weight: .bold))
                                        .foregroundStyle(configModel.strokeColor)
                                    Text(category)
                                        .sleekText()
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .presentationDetents([.fraction(0.6)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    HomeView(selectedView: .constant(0))
        .environmentObject(Config())
}
