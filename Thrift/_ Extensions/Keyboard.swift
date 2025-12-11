//
//  Keyboard.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 13/10/25.
//

import SwiftUI

struct KeyboardToolbarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                                to: nil, from: nil, for: nil)
                    } label: {
                        Text("OK")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.blue)
                    }
                }
            }
    }
}

extension View {
    func dismissKeyboardToolbar() -> some View {
        self.modifier(KeyboardToolbarModifier())
    }
}
