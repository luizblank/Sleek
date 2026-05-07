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
            ZStack {
                HomeView(selectedView: $selectedView)
                    .opacity(selectedView == 0 ? 1 : 0)
                    .allowsHitTesting(selectedView == 0)
                PurchasedView(selectedView: $selectedView)
                    .opacity(selectedView == 1 ? 1 : 0)
                    .allowsHitTesting(selectedView == 1)
            }
        }
    }
}
