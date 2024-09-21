//
//  MyFriendsFeature.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import ComposableArchitecture

@Reducer
struct MyFriendsFeature {
    @ObservableState
    struct State: Equatable {
        var friends = FriendsFeature.State(userType: .me)
        var path = StackState<Path.State>()
    }
    
    enum Action: BindableAction {
        case friends(FriendsFeature.Action)
        case binding(BindingAction<State>)
        
        // MARK: - Transitions
        case path(StackAction<Path.State, Path.Action>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.friends, action: \.friends) {
            FriendsFeature()
        }
        
        Reduce { state, action in
            switch action {
            // MARK: - Transitions
            // MARK: - Profile
            case .friends(.toProfile(let userType)):
                state.path.append(.profile(UserProfileFeature.State(userType: userType)))
                return .none
            case .path(.element(id: _, action: .friends(.toProfile(let userType)))):
                state.path.append(.profile(UserProfileFeature.State(userType: userType)))
                return .none
                
            // MARK: - Friends
            case .path(.element(id: _, action: .profile(.toFriends(let userType)))):
                state.path.append(.friends(FriendsFeature.State(userType: userType)))
                return .none
            
            // MARK: - Communities
            case .path(.element(id: _, action: .profile(.toCommunities(let userType)))):
                state.path.append(.communities(CommunitiesFeature.State(userType: userType)))
                return .none
                
            // MARK: - Photos
            case .path(.element(id: _, action: .profile(.toPhotos(let userType)))):
                state.path.append(.photos(PhotosFeature.State(userType: userType)))
                return .none
                
            case .binding, .path, .friends:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension MyFriendsFeature {
    @Reducer(state: .equatable)
    enum Path {
        case profile(UserProfileFeature)
        case friends(FriendsFeature)
        case communities(CommunitiesFeature)
        case photos(PhotosFeature)
    }
}
