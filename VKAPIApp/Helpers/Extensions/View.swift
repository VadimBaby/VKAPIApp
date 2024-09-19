//
//  View.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 18.09.2024.
//

import SwiftUI

extension View {
    func roundedContainer(
        isContentLoading: Bool,
        isContentEmpty: Bool = false,
        emptyStateMessage: String = "Пусто",
        action: VoidAction? = nil
    ) -> some View {
        Group {
            if isContentLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 70)
            } else if isContentEmpty {
                Text(emptyStateMessage)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if let action {
                Button(action: action) {
                    self
                }
            } else {
                self
            }
        }
        .background(Color.opposite)
        .clipShape(.rect(cornerRadius: 15))
    }
    
    func ignoresSafeAreaBackground(_ color: Color) -> some View {
        self
            .background(color.ignoresSafeArea())
    }
}
