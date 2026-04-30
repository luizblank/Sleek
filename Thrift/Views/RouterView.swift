//
//  RouterView.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 07/12/25.
//

import SwiftUI

struct RouterView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State var selectedView: Int = 0

    var body: some View {
        if !hasSeenOnboarding {
            NavigationStack {
                OnBoarding1()
            }
        } else {
            switch selectedView {
            case 0: HomeView(selectedView: $selectedView)
            case 1: PurchasedView(selectedView: $selectedView)
            default: HomeView(selectedView: $selectedView)
            }
        }
    }
}
