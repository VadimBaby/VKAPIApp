//
//  TabBarFeature.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 10.09.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TabBarFeature {
    @ObservableState
    struct State: Equatable {
        var friendsTab = FriendsTabCoordinator.State()
        var communitiesTab = CommunitiesTabCoordinator.State()
        var profileTab = ProfileTabCoordinator.State()
        
        var currentTab: Tab = .friends
    }
    
    enum Action: BindableAction {
        case changeTab(Tab)
        case binding(BindingAction<State>)
        
        case friendsTab(FriendsTabCoordinator.Action)
        case communitiesTab(CommunitiesTabCoordinator.Action)
        case profileTab(ProfileTabCoordinator.Action)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.friendsTab, action: \.friendsTab) {
            FriendsTabCoordinator()
        }
        
        Scope(state: \.communitiesTab, action: \.communitiesTab) {
            CommunitiesTabCoordinator()
        }
        
        Scope(state: \.profileTab, action: \.profileTab) {
            ProfileTabCoordinator()
        }
        
        Reduce { state, action in
            switch action {
            case .changeTab(let tab):
                state.currentTab = tab
                return .none
            case .profileTab(.userProfile(.toFriends)):
                return .send(.changeTab(.friends))
            case .profileTab(.userProfile(.toCommunities)):
                return .send(.changeTab(.communities))
            case .binding, .friendsTab, .communitiesTab, .profileTab:
                return .none
            }
        }
    }
}


extension TabBarFeature {
    enum Tab: String {
        case friends, communities, profile
        
        var icon: String {
            switch self {
            case .friends: "person.2.fill"
            case .communities: "person.3.fill"
            case .profile: "person.crop.circle"
            }
        }
        
        var title: String {
            switch self {
            case .friends: "Друзья"
            case .communities: "Сообщества"
            case .profile: "Профиль"
            }
        }
    }
}
