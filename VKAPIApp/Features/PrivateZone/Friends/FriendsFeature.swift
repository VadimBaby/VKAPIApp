//
//  FriendsListFeature.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 11.09.2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct FriendsFeature {
    
    @ObservableState
    struct State: Equatable {
        var userId: Int?
        var friends: [User] = []
        var loadableView = LoadableViewFeature.State()
        
        // MARK: - Pagination
        var isPaginationLoading: Bool = false
        var paginationOffset: Int = 0
        var maxFriendsCount: Int = 1
    }
    
    enum Action: BindableAction {
        case onAppear
        case onRefresh
        case onPaginationLoad
        case loadableView(LoadableViewFeature.Action)
        case binding(BindingAction<State>)
        
        // MARK: - Transitions
        case toProfile(Int)
        
        // MARK: - Requests
        case getFriends
        case getFriendsResponse(Result<ResponseModel<User>, Error>)
    }
    
    @Dependency(\.friendsClient) private var friendsClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.loadableView, action: \.loadableView) {
            LoadableViewFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear, .onPaginationLoad:
                return .send(.getFriends)
            case .onRefresh, .loadableView(.onRepeat):
                state.friends = []
                state.paginationOffset = 0
                state.maxFriendsCount = 1
                state.loadableView.error = nil
                
                return .send(.getFriends)
            case .getFriends:
                if state.friends.isEmpty {
                    state.loadableView.screenState = .loading
                } else {
                    state.isPaginationLoading = true
                }
                
                return .run { [userId = state.userId, offset = state.paginationOffset] send in
                    await send(.getFriendsResponse(
                        Result {
                            switch userId {
                            case .some(let id):
                                try await friendsClient.getList(
                                    .user(id: id),
                                    offset,
                                    Constants.paginationCount
                                )
                            case .none:
                                try await friendsClient.getList(
                                    .my,
                                    offset,
                                    Constants.paginationCount
                                )
                            }
                        }
                    ))
                }
            case let .getFriendsResponse(.success(result)):
                defer { state.loadableView.screenState = .loaded }
                
                if let count = result.count {
                    state.maxFriendsCount = count
                }
                
                guard state.friends.count < state.maxFriendsCount else { return .none }
                
                if state.isPaginationLoading {
                    state.friends.append(contentsOf: result.items)
                    state.isPaginationLoading = false
                } else {
                    state.friends = result.items
                }
                
                state.paginationOffset += Constants.paginationCount
                
                return .none
            case let .getFriendsResponse(.failure(error)):
                state.loadableView.error = .init(from: error)
                return .none
            case .binding, .loadableView, .toProfile:
                return .none
            }
        }
    }
}

fileprivate enum Constants {
    static let paginationCount = 20
}
