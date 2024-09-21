//
//  MyProfileFeature.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 20.09.2024.
//

import ComposableArchitecture

@Reducer
struct MyProfileFeature {
    @ObservableState
    struct State: Equatable {
        var userProfile = UserProfileFeature.State(userType: .me)
        
        // MARK: - Transitions
        var path = StackState<Path.State>()
    }
    
    enum Action: BindableAction {
        case userProfile(UserProfileFeature.Action)
        case binding(BindingAction<State>)
        
        // MARK: - Transitions
        case path(StackAction<Path.State, Path.Action>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.userProfile, action: \.userProfile) {
            UserProfileFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .userProfile(.toPhotos):
                state.path.append(.photos(PhotosFeature.State(userType: .me)))
                return .none
            case .path, .binding, .userProfile:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension MyProfileFeature {
    @Reducer(state: .equatable)
    enum Path {
        case photos(PhotosFeature)
    }
}
