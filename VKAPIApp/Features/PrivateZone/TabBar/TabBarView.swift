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
            communitiesTabView
            profileTabView
        }
        .tint(Color.mint)
    }
}

private extension TabBarView {
    @ViewBuilder
    var friendsTabView: some View {
        let tab = TabBarFeature.Tab.friends
        
        FriendsTabView(store: store.scope(state: \.friendsTab, action: \.friendsTab))
            .tabItem {
                Label(tab.title, systemImage: tab.icon)
            }
            .tag(tab)
    }
    
    @ViewBuilder
    var communitiesTabView: some View {
        let tab = TabBarFeature.Tab.communities
        
        CommunitiesTabView(store: store.scope(state: \.communitiesTab, action: \.communitiesTab))
            .tabItem {
                Label(tab.title, systemImage: tab.icon)
            }
            .tag(tab)
    }
    
    @ViewBuilder
    var profileTabView: some View {
        let tab = TabBarFeature.Tab.profile
        
        ProfileTabView(store: store.scope(state: \.profileTab, action: \.profileTab))
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
