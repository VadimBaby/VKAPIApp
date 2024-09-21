//
//  MyCommunitiesFeature.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import ComposableArchitecture

@Reducer
struct MyCommunitiesFeature {
    @ObservableState
    struct State: Equatable {
        var communities = CommunitiesFeature.State(userType: .me)
    }
    
    enum Action: BindableAction {
        case communities(CommunitiesFeature.Action)
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.communities, action: \.communities) {
            CommunitiesFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .binding, .communities:
                return .none
            }
        }
    }
}
