//
//  ProfileFeature.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 17.09.2024.
//

import ComposableArchitecture

@Reducer
struct UserFeature {
    @ObservableState
    struct State: Equatable {
        let userType: UserType
        var loadableView = LoadableViewFeature.State()
        
        // MARK: - Profile
        var isProfileLoading: Bool = false
        var profile: User = .empty
        
        // MARK: - Friends
        var isFriendsLoading: Bool = false
        var friends: [User] = []
        var friendsCommonCount: Int = 0
        
        // MARK: - Communities
        var isCommunitiesLoading: Bool = false
        var communities: [Community] = []
        var communitiesCommonCount: Int = 0
        
        // MARK: - Photo
        var isPhotosLoading = false
        var photos: [Photo] = []
        var photosSizes: [PhotoSize] {
            photos.flatMap(\.sizes).filter{ $0.type == "m" }
        }
    }
    
    enum Action: BindableAction {
        case onAppear
        case onRefresh
        case loadableView(LoadableViewFeature.Action)
        case binding(BindingAction<State>)
        
        // MARK: - Transitions
        case toFriends(UserType)
        case toCommunities(UserType)
        case toPhotos(UserType)
        
        // MARK: - Requests
        case allDataRequests
        case profileRequest
        case profileResponse(Result<User, Error>)
        case friendsRequest
        case friendsResponse(Result<ArrayInnerResponseModel<User>, Error>)
        case communitiesRequest
        case communitiesResponse(Result<ArrayInnerResponseModel<Community>, Error>)
        case photosRequest
        case photosResponse(Result<[Photo], Error>)
    }
    
    @Dependency(\.friendsClient) private var friendsClient
    @Dependency(\.profileClient) private var profileClient
    @Dependency(\.communitiesClient) private var communitiesClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.loadableView, action: \.loadableView) {
            LoadableViewFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear, .loadableView(.onRepeat):
                state.loadableView.screenState = .loaded
                
                return .send(.allDataRequests)
            case .onRefresh:
                state.loadableView.screenState = .loaded
                
                state.isProfileLoading = false
                state.profile = .empty
                
                state.isFriendsLoading = false
                state.friends = []
                state.friendsCommonCount = 0
                
                state.isPhotosLoading = false
                state.photos = []
                
                return .send(.allDataRequests)
            case .allDataRequests:
                return .merge(
                    .send(.profileRequest),
                    .send(.friendsRequest),
                    .send(.communitiesRequest),
                    .send(.photosRequest)
                )
            
            // MARK: - Profile
            case .profileRequest:
                state.isProfileLoading = true
                return .run { [userType = state.userType] send in
                    await send(
                        .profileResponse(
                            Result {
                                try await profileClient.getProfile(userType)
                            }
                        )
                    )
                }
            case let .profileResponse(.success(profile)):
                defer { state.isProfileLoading = false }
                state.profile = profile
                return .none
                
            // MARK: - Friends
            case .friendsRequest:
                state.isFriendsLoading = true
                return .run { [userType = state.userType] send in
                    await send(
                        .friendsResponse(
                            Result {
                                try await friendsClient.getList(
                                    userType,
                                    Constants.offset,
                                    Constants.count
                                )
                            }
                        )
                    )
                }
            case let .friendsResponse(.success(result)):
                defer { state.isFriendsLoading = false }
                state.friends = result.items
                state.friendsCommonCount = result.count.orZero
                return .none
                
            // MARK: - Community
            case .communitiesRequest:
                state.isCommunitiesLoading = true
                return .run { [userType = state.userType] send in
                    await send(
                        .communitiesResponse(
                            Result {
                                try await communitiesClient.getList(
                                    userType,
                                    Constants.offset,
                                    Constants.count
                                )
                            }
                        )
                    )
                }
            case let .communitiesResponse(.success(result)):
                defer { state.isCommunitiesLoading = false }
                state.communities = result.items
                state.communitiesCommonCount = result.count.orZero
                return .none
                
            // MARK: - Photos
            case .photosRequest:
                state.isPhotosLoading = true
                return .run { [userType = state.userType] send in
                    await send(
                        .photosResponse(
                            Result {
                                try await profileClient.getPhotos(userType, .wall)
                            }
                        )
                    )
                }
            case let .photosResponse(.success(photos)):
                defer { state.isPhotosLoading = false }
                state.photos = photos
                return .none
            
            // MARK: - Errors
            case let .profileResponse(.failure(error)),
                let .friendsResponse(.failure(error)),
                let .communitiesResponse(.failure(error)),
                let .photosResponse(.failure(error)):
                state.loadableView.error = ErrorEntity(from: error)
                return .none
            case .loadableView, .binding, .toFriends, .toCommunities, .toPhotos:
                return .none
            }
        }
    }
}

fileprivate enum Constants {
    static let offset = 0
    static let count = 4
}
