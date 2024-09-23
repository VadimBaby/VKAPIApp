//
//  CommunityProfileFeature.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import ComposableArchitecture

@Reducer
struct CommunityFeature {
    @ObservableState
    struct State: Equatable {
        var community: Community
        var loadableView = LoadableViewFeature.State()
        
        // MARK: - Members
        var isMembersLoading: Bool = false
        var members: [User] = []
        var membersCommonCount: Int = 0
    }
    
    enum Action: BindableAction {
        case onAppear
        case onRefresh
        case loadableView(LoadableViewFeature.Action)
        case binding(BindingAction<State>)
        
        // MARK: - Request
        case getMembers
        case getMembersResponse(Result<ArrayInnerResponseModel<User>, Error>)
    }
    
    @Dependency(\.communitiesClient) private var communitiesClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.loadableView, action: \.loadableView) {
            LoadableViewFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.loadableView.screenState = .loaded
                return .send(.getMembers)
            case .onRefresh, .loadableView(.onRepeat):
                state.members = []
                return .send(.getMembers)
                
            // MARK: - Members
            case .getMembers:
                state.isMembersLoading = true
                return .run { [id = state.community.id] send in
                    await send(
                        .getMembersResponse(
                            Result {
                                try await communitiesClient.getMembers(
                                    id,
                                    Constants.offset,
                                    Constants.count
                                )
                            }
                        )
                    )
                }
            case let .getMembersResponse(.success(result)):
                defer { state.isMembersLoading = false }
                state.members = result.items
                state.membersCommonCount = result.count.orZero
                return .none
            case let .getMembersResponse(.failure(error)):
                state.loadableView.error = ErrorEntity(from: error)
                return .none
            case .binding, .loadableView:
                return .none
            }
        }
    }
}

fileprivate enum Constants {
    static let offset = 0
    static let count = 4
}
