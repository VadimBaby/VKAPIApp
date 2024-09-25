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
    
    @State private var animatedTabs: [AnimatedTab] = TabBarFeature.Tab.allCases.map{ .init(tab: $0) }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $store.currentTab) {
                friendsTabView
                communitiesTabView
                profileTabView
            }
            
            tabsView
        }
    }
}

// MARK: - Subviews

private extension TabBarView {
    @ViewBuilder
    var tabsView: some View {
        HStack(spacing: 0) {
            ForEach($animatedTabs) { $animatedTab in
                let tab = animatedTab.tab
                
                VStack(spacing: 4) {
                    Image(systemName: tab.icon)
                        .font(.title2)
                        .symbolEffect(
                            .bounce.down.byLayer, value: animatedTab.isAnimating
                        )
                    
                    Text(tab.title)
                        .font(.caption2)
                        .textScale(.secondary)
                }
                .foregroundStyle(
                    store.currentTab == tab ? Color.primary : Color.gray.opacity(0.8)
                )
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
                .contentShape(.rect)
                .onTapGesture {
                    store.send(.changeTab(tab))
                    withAnimation(.bouncy) {
                        animatedTab.isAnimating = true
                    } completion: {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            animatedTab.isAnimating = nil
                        }
                    }
                }
            }
        }
        .background(Color.primary.opacity(0.05))
    }
}

// MARK: - Tabs

private extension TabBarView {
    @ViewBuilder
    var friendsTabView: some View {
        let tab = TabBarFeature.Tab.friends
        
        FriendsTabView(store: store.scope(state: \.friendsTab, action: \.friendsTab))
            .setupTab(tab)
    }
    
    @ViewBuilder
    var communitiesTabView: some View {
        let tab = TabBarFeature.Tab.communities
        
        CommunitiesTabView(store: store.scope(state: \.communitiesTab, action: \.communitiesTab))
            .setupTab(tab)
    }
    
    @ViewBuilder
    var profileTabView: some View {
        let tab = TabBarFeature.Tab.profile
        
        ProfileTabView(store: store.scope(state: \.profileTab, action: \.profileTab))
            .setupTab(tab)
    }
}

private extension TabBarView {
    struct AnimatedTab: Identifiable, Equatable {
        let id = UUID()
        let tab: TabBarFeature.Tab
        var isAnimating: Bool?
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
