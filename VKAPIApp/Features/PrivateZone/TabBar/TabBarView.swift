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
        
        FriendsListView(store: .init(
            initialState: FriendsListFeature.State(),
            reducer: { FriendsListFeature() }
        ))
        .tabItem {
            Label(tab.title, systemImage: tab.icon)
        }
        .tag(tab)
    }
    
    @ViewBuilder
    var profileTabView: some View {
        let tab = TabBarFeature.Tab.profile
        
        Color.green.ignoresSafeArea()
            .tabItem {
                Label(tab.title, systemImage: tab.icon)
            }
            .tag(tab)
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
