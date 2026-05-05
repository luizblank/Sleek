//
//  Font.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 08/10/25.
//

import SwiftUI

extension Font {
    public static func antonio(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.custom("Antonio-Regular", size: size).weight(weight)
    }
    
    public static func customFont(name: String, size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.custom(name, size: size).weight(weight)
    }
}

enum AppFont: String, CaseIterable, Identifiable {
    case anton = "Anton-Regular"
    case bitcount = "BitcountPropSingle-Regular"
    case fjallaone = "FjallaOne-Regular"
    case leaguespartan = "LeagueSpartan-Thin"
    case nabla = "Nabla-Regular"
    case orbitron = "Orbitron-Regular"
    case antonio = "Antonio-Regular"
    case pacifico = "Pacifico-Regular"
    case permanentmarker = "PermanentMarker-Regular"
    case pixelify = "PixelifySans-Regular"
    case playwritecz = "PlaywriteCZ-Regular"
    case tiny5 = "Tiny5-Regular"
    
    // System
    case helvetica = "Helvetica Neue"
    case avenir = "Avenir Next"
    case gillSans = "Gill Sans"
    case courier = "Courier New"
    case georgia = "Georgia"
    case baskerville = "Baskerville"
    case sfpro = "SF Pro"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        if let uiFont = UIFont(name: self.rawValue, size: 10) {
            return uiFont.familyName
        }
        
        return self.rawValue
    }
}
