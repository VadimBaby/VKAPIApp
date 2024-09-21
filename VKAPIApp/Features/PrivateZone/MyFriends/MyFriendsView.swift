//
//  MyFriendsView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import ComposableArchitecture
import SwiftUI

struct MyFriendsView: View {
    @Bindable var store: StoreOf<MyFriendsFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            FriendsView(store: store.scope(state: \.friends, action: \.friends))
        } destination: { store in
            switch store.case {
            case let .profile(store):
                UserProfileView(store: store)
            case let .friends(store):
                FriendsView(store: store)
            case let .communities(store):
                CommunitiesView(store: store)
            case let .photos(store):
                PhotosView(store: store)
            }
        }
    }
}

#Preview {
    MyFriendsView(store: .init(
        initialState: MyFriendsFeature.State(),
        reducer: { MyFriendsFeature() }
    ))
}
