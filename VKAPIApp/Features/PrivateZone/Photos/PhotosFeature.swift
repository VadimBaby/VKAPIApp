//
//  PhotosFeature.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 19.09.2024.
//

import ComposableArchitecture

@Reducer
struct PhotosFeature {
    @ObservableState
    struct State: Equatable {
        var userId: Int?
        var loadableView = LoadableViewFeature.State()
        
        var photos: [PhotoSize] = []
    }
    
    enum Action: BindableAction {
        case onAppear
        case onRefresh
        case loadableView(LoadableViewFeature.Action)
        case binding(BindingAction<State>)
        
        case photosRequest
        case photosResponse(Result<[Photo], Error>)
    }
    
    @Dependency(\.profileClient) private var profileClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.loadableView, action: \.loadableView) {
            LoadableViewFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear, .loadableView(.onRepeat):
                state.loadableView.screenState = .loading
                return .send(.photosRequest)
            case .onRefresh:
                state.photos = []
                return .send(.photosRequest)
            case .photosRequest:
                return .run { [userId = state.userId] send in
                    await send(.photosResponse(
                        Result {
                            switch userId {
                            case .some(let id):
                                try await profileClient.getPhotos(.user(id: id), .profile)
                            case .none:
                                try await profileClient.getPhotos(.my, .profile)
                            }
                        }
                    ))
                }
            case let .photosResponse(.success(models)):
                state.photos = models.flatMap(\.sizes).filter{ $0.type == "s" }
                state.loadableView.screenState = .loaded
                return .none
            case let .photosResponse(.failure(error)):
                state.loadableView.error = .init(from: error)
                return .none
            case .binding, .loadableView:
                return .none
            }
        }
    }
}
