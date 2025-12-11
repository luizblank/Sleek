//
//  ShareView.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 01/12/25.
//

import SwiftUI

struct ShareView: View {
    var image: UIImage?
    
    var onSave: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(.blankLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
                .padding(.top)
            
            Spacer()
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding()
            } else {
                ProgressView("Processing image...")
            }
            
            Spacer()
            
            HStack {
                Button(action: onCancel) {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .stroke()
                        .frame(width: 116, height: 48)
                        .background(.white)
                        .clipShape(Capsule())
                        .stroke()
                }
                Spacer()
                Button(action: onSave) {
                    Text("Add to wishlist")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .stroke()
                        .frame(width: 116, height: 48)
                        .background(.white)
                        .clipShape(Capsule())
                        .stroke()
                }
                .disabled(image == nil)
                .opacity(image == nil ? 0.5 : 1.0)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(.sleekPink)
    }
}
