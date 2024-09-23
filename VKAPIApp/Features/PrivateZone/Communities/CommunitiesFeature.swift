//
//  CommunitiesFeature.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import ComposableArchitecture

@Reducer
struct CommunitiesFeature {
    @ObservableState
    struct State: Equatable {
        let userType: UserType
        var communities: [Community] = []
        var loadableView = LoadableViewFeature.State()
        
        // MARK: - Pagination
        var isPaginationLoading: Bool = false
        var paginationOffset: Int = 0
        var maxCommunitiesCount: Int = 1
    }
    
    enum Action: BindableAction {
        case onAppear
        case onRefresh
        case onPaginationLoad
        case loadableView(LoadableViewFeature.Action)
        case binding(BindingAction<State>)
        
        // MARK: - Requests
        case getCommunities
        case getCommunitiesResponse(Result<ArrayInnerResponseModel<Community>, Error>)
        
        // MARK: - Transitions
        case toCommunityProfile(Community)
    }
    
    @Dependency(\.communitiesClient) private var communitiesClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.loadableView, action: \.loadableView) {
            LoadableViewFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear, .onPaginationLoad:
                return .send(.getCommunities)
            case .onRefresh, .loadableView(.onRepeat):
                state.communities = []
                state.paginationOffset = 0
                return .send(.getCommunities)
                
            // MARK: - Communities
            case .getCommunities:
                if state.communities.isEmpty {
                    state.loadableView.screenState = .loading
                } else {
                    state.isPaginationLoading = true
                }
                
                return .run { [userType = state.userType, offset = state.paginationOffset] send in
                    await send(
                        .getCommunitiesResponse(
                            Result {
                                try await communitiesClient.getList(
                                    userType,
                                    offset,
                                    Constants.paginationCount
                                )
                            }
                        )
                    )
                }
            case let .getCommunitiesResponse(.success(result)):
                defer { state.loadableView.screenState = .loaded }
                
                if let count = result.count {
                    state.maxCommunitiesCount = count
                }
                
                guard state.communities.count < state.maxCommunitiesCount else { return .none }
                
                if state.isPaginationLoading {
                    state.communities.append(contentsOf: result.items)
                    state.isPaginationLoading = false
                } else {
                    state.communities = result.items
                }
                
                state.paginationOffset += Constants.paginationCount
                
                return .none
            case let .getCommunitiesResponse(.failure(error)):
                state.loadableView.error = ErrorEntity(from: error)
                return .none
            case .binding, .loadableView, .toCommunityProfile:
                return .none
            }
        }
    }
}

fileprivate enum Constants {
    static let paginationCount = 20
}
