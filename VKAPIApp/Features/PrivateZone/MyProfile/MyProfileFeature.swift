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
        var profile = ProfileFeature.State()
        
        // MARK: - Transitions
        var path = StackState<Path.State>()
    }
    
    enum Action: BindableAction {
        case profile(ProfileFeature.Action)
        case binding(BindingAction<State>)
        
        // MARK: - Transitions
        case path(StackAction<Path.State, Path.Action>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.profile, action: \.profile) {
            ProfileFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .profile(.toPhotos):
                state.path.append(.photos(PhotosFeature.State()))
                return .none
            case .path, .binding, .profile:
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
