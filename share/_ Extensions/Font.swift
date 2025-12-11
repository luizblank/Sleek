//
//  Font.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 08/10/25.
//

import SwiftUI

extension Font {
    public static func anton(size: CGFloat) -> Font {
        return Font.custom("Anton", size: size)
    }
    
    public static func antonio(size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        return Font.custom("Antonio", size: size).weight(weight)
    }
}
