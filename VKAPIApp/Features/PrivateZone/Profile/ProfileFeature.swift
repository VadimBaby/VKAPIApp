//
//  ProfileFeature.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 17.09.2024.
//

import ComposableArchitecture

@Reducer
struct ProfileFeature {
    
    @ObservableState
    struct State {
        var loadableView = LoadableViewFeature.State()
        
        // MARK: - Profile
        var isProfileLoading: Bool = false
        var profile: User = .empty
        
        // MARK: - Friends
        var isFriendsLoading: Bool = false
        var friends: [User] = []
        var friendsCommonCount: Int = 0
        
        // MARK: - Photo
        var isPhotosLoading = false
        var photos: [Photo] = []
        var photosSizes: [PhotoSize] {
            photos.flatMap(\.sizes)
        }
    }
    
    enum Action: BindableAction {
        case onAppear
        case onRefresh
        case loadableView(LoadableViewFeature.Action)
        case binding(BindingAction<State>)
        
        // MARK: - Requests
        case allDataRequest
        case profileRequest
        case profileResponse(Result<User, Error>)
        case friendsRequest
        case friendsResponse(Result<ResponseModel<User>, Error>)
        case photosRequest
        case photosResponse(Result<[Photo], Error>)
    }
    
    @Dependency(\.friendsClient) private var friendsClient
    @Dependency(\.profileClient) private var profileClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.loadableView, action: \.loadableView) {
            LoadableViewFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear, .loadableView(.onRepeat):
                state.loadableView.screenState = .loaded
                
                return .send(.allDataRequest)
            case .onRefresh:
                state.loadableView.screenState = .loaded
                
                state.isProfileLoading = false
                state.profile = .empty
                
                state.isFriendsLoading = false
                state.friends = []
                state.friendsCommonCount = 0
                
                state.isPhotosLoading = false
                state.photos = []
                
                return .send(.allDataRequest)
            case .allDataRequest:
                return .merge(
                    .send(.profileRequest),
                    .send(.friendsRequest),
                    .send(.photosRequest)
                )
            
            // MARK: - Profile
            case .profileRequest:
                state.isProfileLoading = true
                return .run { send in
                    await send(
                        .profileResponse(
                            Result {
                                try await profileClient.getProfile()
                            }
                        )
                    )
                }
            case let .profileResponse(.success(model)):
                state.profile = model
                state.isProfileLoading = false
                return .none
                
            // MARK: - Friends
            case .friendsRequest:
                state.isFriendsLoading = true
                return .run { send in
                    await send(
                        .friendsResponse(
                            Result {
                                try await friendsClient.getList(
                                    Constants.friendsOffset,
                                    Constants.friendsCount
                                )
                            }
                        )
                    )
                }
            case let .friendsResponse(.success(model)):
                state.friends = model.items
                state.friendsCommonCount = model.count.orZero
                state.isFriendsLoading = false
                return .none
                
            // MARK: - Photos
            case .photosRequest:
                state.isPhotosLoading = true
                return .run { send in
                    await send(
                        .photosResponse(
                            Result {
                                try await profileClient.getPhotos(nil)
                            }
                        )
                    )
                }
            case let .photosResponse(.success(models)):
                state.photos = models
                state.isPhotosLoading = false
                return .none
            
            // MARK: - Errors
            case let .profileResponse(.failure(error)),
                let .friendsResponse(.failure(error)),
                let .photosResponse(.failure(error)):
                state.loadableView.error = .init(from: error)
                return .none
            case .loadableView, .binding:
                return .none
            }
        }
    }
}

fileprivate enum Constants {
    static let friendsOffset = 0
    static let friendsCount = 4
}
