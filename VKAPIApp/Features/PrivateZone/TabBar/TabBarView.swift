//
//  TabBarView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 10.09.2024.
//

import SwiftUI
import ComposableArchitecture

struct TabBarView: View {
    
    @Bindable var store: StoreOf<TabBarFeature>
    
    var body: some View {
        TabView(selection: $store.currentTab) {
            friendsTabView
            profileTabView
        }
        .tint(Color.mint)
    }
}

private extension TabBarView {
    @ViewBuilder
    var friendsTabView: some View {
        let tab = TabBarFeature.Tab.friends
        
        Color.red.ignoresSafeArea()
            .tabItem {
                Label(tab.title, systemImage: tab.icon)
            }
            .tag(tab)
            .safeAreaInset(edge: .top) { navigateToTabButton(.profile) }
    }
    
    @ViewBuilder
    var profileTabView: some View {
        let tab = TabBarFeature.Tab.profile
        
        Color.green.ignoresSafeArea()
            .tabItem {
                Label(tab.title, systemImage: tab.icon)
            }
            .tag(tab)
            .safeAreaInset(edge: .top) { navigateToTabButton(.friends) }
    }
    
    @ViewBuilder func navigateToTabButton(_ tab: TabBarFeature.Tab) -> some View {
        Button("To \(tab.rawValue.capitalized)") {
            store.send(.change(tab: tab))
        }
        .foregroundStyle(Color.white)
        .padding()
        .background(Color.black)
        .padding(.top)
    }
}

#Preview {
    TabBarView(store: .init(
        initialState: TabBarFeature.State(),
        reducer: {
            TabBarFeature()
        }
    ))
}
