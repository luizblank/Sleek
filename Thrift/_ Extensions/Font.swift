//
//  Font.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 08/10/25.
//

import SwiftUI

extension Font {
    public static func antonio(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.custom("Antonio", size: size).weight(weight)
    }
    
    public static func customFont(name: String, size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.custom(name, size: size).weight(weight)
    }
}

enum AppFont: String, CaseIterable, Identifiable {
    case anton = "Anton"
    case bitcount = "BitcountPropSingle-Regular"
    case fjallaone = "FjallaOne-Regular"
    case leaguespartan = "LeagueSpartan-Regular"
    case nabla = "Nabla"
    case orbitron = "Orbitron"
    case antonio = "Antonio"
    case pacifico = "Pacifico"
    case permanentmarker = "PermanentMarker-Regular"
    case pixelify = "PixelifySans-Regular"
    case playwritecz = "PlayWriteCZ-Regular"
    case tiny5 = "Tiny5"
    
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
