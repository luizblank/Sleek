//
//  Outline.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 08/10/25.
//

import SwiftUI

extension View {
    func stroke(_ color: Color? = nil, _ width: CGFloat = 1.8, disable: Bool = false) -> some View {
        modifier(StrokeModifier(color: color, strokeSize: width, disable: disable))
    }
}

struct StrokeModifier: ViewModifier {
    @EnvironmentObject private var configModel: Config
    
    private let id = UUID()
    var color: Color?
    var strokeSize: CGFloat
    var disable: Bool

    func body(content: Content) -> some View {
        if strokeSize > 0 && !disable {
            appliedStrokeBackground(content: content)
        } else {
            content
        }
    }

    private func appliedStrokeBackground(content: Content) -> some View {
        content
            .padding(strokeSize*2)
            .background(
                Rectangle()
                    .foregroundColor(color != nil ? color : configModel.strokeColor)
                    .mask(alignment: .center) {
                        mask(content: content)
                    }
            )
    }

    func mask(content: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            if let resolvedView = context.resolveSymbol(id: id) {
                context.draw(resolvedView, at: .init(x: size.width/2, y: size.height/2))
            }
        } symbols: {
            content
                .tag(id)
                .blur(radius: strokeSize)
        }
    }
}
