//
//  MyProfileView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 20.09.2024.
//

import ComposableArchitecture
import SwiftUI

struct MyProfileView: View {
    @Bindable var store: StoreOf<MyProfileFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            UserProfileView(store: store.scope(state: \.userProfile, action: \.userProfile))
        } destination: { store in
            switch store.case {
            case let .photos(store):
                PhotosView(store: store)
            }
        }
    }
}

#Preview {
    MyProfileView(store: .init(
        initialState: MyProfileFeature.State(),
        reducer: { MyProfileFeature() }
    ))
}
