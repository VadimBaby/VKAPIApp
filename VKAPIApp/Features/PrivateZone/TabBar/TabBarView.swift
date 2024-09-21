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
        
        MyFriendsView(store: store.scope(state: \.myFriends, action: \.myFriends))
            .tabItem {
                Label(tab.title, systemImage: tab.icon)
            }
            .tag(tab)
    }
    
    @ViewBuilder
    var communitiesTabView: some View {
        let tab = TabBarFeature.Tab.communities
        
        MyCommunitiesView(store: store.scope(state: \.myCommunities, action: \.myCommunities))
            .tabItem {
                Label(tab.title, systemImage: tab.icon)
            }
            .tag(tab)
    }
    
    @ViewBuilder
    var profileTabView: some View {
        let tab = TabBarFeature.Tab.profile
        
        MyProfileView(store: store.scope(state: \.myProfile, action: \.myProfile))
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
