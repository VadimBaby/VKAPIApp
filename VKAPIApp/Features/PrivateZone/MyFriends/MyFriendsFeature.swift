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
            case .friends(.toProfile(let userType)):
                state.path.append(.profile(ProfileFeature.State(userType: userType)))
                return .none
                
            case .path(.element(id: _, action: .friends(.toProfile(let userType)))):
                state.path.append(.profile(ProfileFeature.State(userType: userType)))
                return .none
                
            case .path(.element(id: _, action: .profile(.toFriends(let userType)))):
                state.path.append(.friends(FriendsFeature.State(userType: userType)))
                return .none
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
        case profile(ProfileFeature)
        case friends(FriendsFeature)
        case photos(PhotosFeature)
    }
}
