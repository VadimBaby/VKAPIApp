//
//  ContentView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 04.09.2024.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    @AppStorage(UserStorageKey.token.rawValue) var token: String = ""
    
    var body: some View {
        if token.isEmpty, let url = AuthURLBuilder.current.url {
            AuthWebView(authURL: url)
        } else {
            TabBarView(store: .init(
                initialState: TabBarFeature.State(),
                reducer: {
                    TabBarFeature()
                }
            ))
            .onFirstAppear(perform: setupTabBar)
        }
    }
}

private extension ContentView {
    func setupTabBar() {
        UITabBar.appearance().unselectedItemTintColor = .black
    }
}

#Preview {
    ContentView()
}
