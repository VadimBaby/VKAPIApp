//
//  MyCommunitiesFeature.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import ComposableArchitecture

@Reducer
struct CommunitiesTabCoordinator {
    @ObservableState
    struct State: Equatable {
        var communities = CommunitiesFeature.State(userType: .me)
        
        // MARK: - Transitions
        var path = StackState<Path.State>()
    }
    
    enum Action: BindableAction {
        case communities(CommunitiesFeature.Action)
        case binding(BindingAction<State>)
        
        // MARK: - Transitions
        case path(StackAction<Path.State, Path.Action>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.communities, action: \.communities) {
            CommunitiesFeature()
        }
        
        Reduce { state, action in
            switch action {
            // MARK: - Transitions
            case .communities(.toCommunityProfile(let community)):
                state.path.append(.communityProfile(CommunityProfileFeature.State(community: community)))
                return .none
            case .binding, .communities, .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension CommunitiesTabCoordinator {
    @Reducer(state: .equatable)
    enum Path {
        case communityProfile(CommunityProfileFeature)
    }
}
