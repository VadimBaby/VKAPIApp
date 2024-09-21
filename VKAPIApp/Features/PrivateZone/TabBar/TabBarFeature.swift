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
        var myFriends = MyFriendsFeature.State()
        var myCommunities = MyCommunitiesFeature.State()
        var myProfile = MyProfileFeature.State()
        
        var currentTab: Tab = .friends
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case myFriends(MyFriendsFeature.Action)
        case myCommunities(MyCommunitiesFeature.Action)
        case myProfile(MyProfileFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.myFriends, action: \.myFriends) {
            MyFriendsFeature()
        }
        
        Scope(state: \.myCommunities, action: \.myCommunities) {
            MyCommunitiesFeature()
        }
        
        Scope(state: \.myProfile, action: \.myProfile) {
            MyProfileFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .binding, .myFriends, .myCommunities, .myProfile:
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
