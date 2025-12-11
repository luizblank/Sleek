//
//  LinksForm.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 13/10/25.
//

import SwiftUI

struct LinksForm: View {
    @EnvironmentObject private var configModel: Config
    @Binding var item: Item
    
    @State var newLink: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            HStack {
                Text("Add links")
                    .sleekText(.medium)
                    .padding(.top, 32)
                    .padding(.bottom, 12)
                Spacer()
            }
            
            HStack {
                TextField("", text: $newLink, prompt: Text("Add a link...").foregroundStyle(.black.opacity(0.7)))
                    .padding(.horizontal)
                    .foregroundStyle(.black)
                    .font(.customFont(name: configModel.font, size: textSizes.normal.rawValue))
                    .onSubmit {
                        if newLink.isEmpty { return }
                        withAnimation {
                            item.links.append(newLink.lowercased())
                        }
                        newLink = ""
                    }
                
                Button {
                    if newLink.isEmpty || item.links.contains(newLink) { return }
                    withAnimation {
                        item.links.append(newLink)
                    }
                    newLink = ""
                } label: {
                    Image(systemName: "plus")
                        .sleekText(weight: .bold)
                        .frame(width: 42, height: 42)
                        .background(configModel.textColor)
                        .clipShape(Capsule())
                        .stroke()
                }
            }
            .padding(4)
            .background(.black.opacity(0.1))
            .clipShape(Capsule())
            
            ScrollView {
                ForEach(item.links, id: \.self) { link in
                    HStack(alignment: .center) {
                        Text(link)
                            .font(.customFont(name: configModel.font, size: textSizes.normal.rawValue))
                            .foregroundStyle(.black)
                            .lineLimit(1)
                        Spacer()
                    }
                    .frame(width: 330, height: 24)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(configModel.textColor)
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
    LinksForm(item: .constant(Item.mock))
        .environmentObject(Config())
}
