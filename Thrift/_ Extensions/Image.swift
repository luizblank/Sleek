//
//  Image.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 13/10/25.
//

import SwiftUI

extension Image {
    init(source image: UIImage?, fallbackSystemName: String) {
        if let image {
            self = Image(uiImage: image)
        } else {
            self = Image(systemName: fallbackSystemName)
        }
    }
}
