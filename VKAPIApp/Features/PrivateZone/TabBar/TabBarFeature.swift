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
    struct State {
        var friends = FriendsListFeature.State()
        var profile = ProfileFeature.State()
        
        var currentTab: Tab = .friends
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case friends(FriendsListFeature.Action)
        case profile(ProfileFeature.Action)
        
        case change(tab: Tab)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.friends, action: \.friends) {
            FriendsListFeature()
        }
        
        Scope(state: \.profile, action: \.profile) {
            ProfileFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .change(let tab):
                state.currentTab = tab
                return .none
            case .binding, .friends, .profile:
                print("change")
                return .none
            }
        }
    }
}


extension TabBarFeature {
    enum Tab: String {
        case friends, profile
        
        var icon: String {
            switch self {
            case .friends: "person.2.fill"
            case .profile: "person.crop.circle"
            }
        }
        
        var title: String {
            switch self {
            case .friends: "Друзья"
            case .profile: "Профиль"
            }
        }
    }
}
