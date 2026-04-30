//
//  ShareView.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 01/12/25.
//

import SwiftUI

struct ShareView: View {
    var images: [UIImage]
    var isLoading: Bool

    var onSave: () -> Void
    var onCancel: () -> Void

    private var saveButtonLabel: String {
        images.count > 1 ? "Add \(images.count) items" : "Add to wishlist"
    }

    var body: some View {
        VStack(spacing: 20) {
            Image(.blankLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
                .padding(.top)

            if isLoading {
                Spacer()
                ProgressView("Processing image...")
                Spacer()
            } else if images.isEmpty {
                Spacer()
                Text("No images found")
                    .foregroundColor(.white)
                Spacer()
            } else if images.count == 1, let only = images.first {
                Image(uiImage: only)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(images.enumerated()), id: \.offset) { _, image in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 8)
            }

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
                    Text(saveButtonLabel)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .stroke()
                        .frame(width: 160, height: 48)
                        .background(.white)
                        .clipShape(Capsule())
                        .stroke()
                }
                .disabled(images.isEmpty)
                .opacity(images.isEmpty ? 0.5 : 1.0)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(.sleekPink)
    }
}
