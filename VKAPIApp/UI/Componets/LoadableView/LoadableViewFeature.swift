//
//  LoadableViewFeature.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 12.09.2024.
//

import ComposableArchitecture

enum LoadableScreenState: Equatable {
    case loading, loaded
}

@Reducer
struct LoadableViewFeature {
    
    @ObservableState
    struct State: Equatable {
        var screenState: LoadableScreenState = .loaded
        var error: ErrorEntity? = nil
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onRepeat
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onRepeat:
                state.screenState = .loading
                state.error = nil
                return .none
            case .binding:
                return .none
            }
        }
    }
}


