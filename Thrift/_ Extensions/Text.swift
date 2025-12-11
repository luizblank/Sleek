//
//  Text.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 04/12/25.
//

import SwiftUI

extension View {
    func sleekText(
        _ size: textSizes = .normal,
        weight: Font.Weight = .regular,
        disableStroke: Bool = false,
        defaultText: Bool = false
    ) -> some View {
        modifier(SleekModifier(size, weight, disableStroke, defaultText))
    }
}

struct SleekModifier: ViewModifier {
    @EnvironmentObject private var configModel: Config
    
    var size: textSizes
    var weight: Font.Weight
    var disableStroke: Bool
    var defaultText: Bool = true
    
    init(_ size: textSizes, _ weight: Font.Weight, _ disableStroke: Bool, _ defaultText: Bool) {
        self.size = size
        self.weight = weight
        self.disableStroke = disableStroke
        self.defaultText = defaultText
    }

    func body(content: Content) -> some View {
        content
            .font(.customFont(name: defaultText ? "Antonio" : configModel.font, size: size.rawValue, weight: weight))
            .foregroundStyle(defaultText ? .white : configModel.textColor)
            .stroke(defaultText ? .black : nil, disable: disableStroke)
    }
}

enum textSizes: CGFloat {
    case extraLarge = 36
    case large = 28
    case medium = 24
    case normal = 20
    case small = 16
}

