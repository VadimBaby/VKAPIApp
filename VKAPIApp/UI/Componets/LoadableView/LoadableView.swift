//
//  LoadableView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 12.09.2024.
//

import ComposableArchitecture
import SwiftUI

struct LoadableView<Content: View>: View {
    
    @Bindable var store: StoreOf<LoadableViewFeature>
    let content: () -> Content
    
    var body: some View {
        Group {
            switch store.screenState {
            case .loading:
                CircleProgressView()
            case .loaded:
                content()
            }
        }
        .fullScreenCover(item: $store.error) { error in
            ErrorView(
                description: error.description,
                onRepeat: repeatAction
            )
        }
    }
}

private extension LoadableView {
    func repeatAction() {
        store.send(.onRepeat)
    }
}

#Preview {
    LoadableView(store: .init(
        initialState: LoadableViewFeature.State(),
        reducer: { LoadableViewFeature() }
    )) {
        Text("Content")
    }
}
