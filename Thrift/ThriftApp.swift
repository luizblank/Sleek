//
//  ThriftApp.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 07/10/25.
//

import SwiftUI
import SwiftData

@main
struct ThriftApp: App {
    @StateObject private var configModel = Config()
    
    var body: some Scene {
        WindowGroup {
            RouterView()
                .modelContainer(for: Item.self)
                .preferredColorScheme(.light)
                .environmentObject(configModel)
        }
    }
}
