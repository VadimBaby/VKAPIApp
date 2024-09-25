//
//  View.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 18.09.2024.
//

import SwiftUI

extension View {
    func roundedContainer(
        isContentLoading: Bool = false,
        isContentEmpty: Bool = false,
        emptyContent: EmptyContentView? = nil,
        action: VoidAction? = nil
    ) -> some View {
        Group {
            if isContentLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 70)
                    .background(Color.opposite)
                    .clipShape(.rect(cornerRadius: 15))
            } else if let emptyContent, isContentEmpty {
                emptyContent
            } else {
                Group {
                    if let action {
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
        }
    }
    
    func ignoresSafeAreaBackground(_ color: Color) -> some View {
        self
            .background(color.ignoresSafeArea())
    }
    
    func setupTab(_ tab: TabBarFeature.Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
}
