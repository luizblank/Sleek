//
//  Config.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 02/12/25.
//

import SwiftUI

class Config: ObservableObject {
    @Published var backgroundColor: Color = Color(hex: UserDefaults.standard.string(forKey: "backgroundColor") ?? "#e55381")
    @Published var backgroundImage: UIImage? = UserDefaults.standard.data(forKey: "backgroundImage") != nil ? UIImage(data: UserDefaults.standard.data(forKey: "backgroundImage")!) : nil
    
    @Published var strokeColor: Color = Color(hex: UserDefaults.standard.string(forKey: "strokeColor") ?? "#000000")

    @Published var textColor: Color = Color(hex: UserDefaults.standard.string(forKey: "textColor") ?? "#ffffff")
    
    @Published var logo: String = UserDefaults.standard.string(forKey: "logo") ?? "horizontalLogo"
    @Published var font: String = UserDefaults.standard.string(forKey: "font") ?? "Antonio"
}
