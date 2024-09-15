//
//  FirstAppearModifier.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 10.09.2024.
//

import Foundation
import SwiftUI

struct FirstAppearModifier: ViewModifier {
    
    @State private var isFirstAppear: Bool = true
    let action: VoidAction
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                guard isFirstAppear else { return }
                defer { isFirstAppear = false  }
                action()
            }
    }
}

extension View {
    func onFirstAppear(perform action: @escaping VoidAction) -> some View {
        modifier(FirstAppearModifier(action: action))
    }
}
