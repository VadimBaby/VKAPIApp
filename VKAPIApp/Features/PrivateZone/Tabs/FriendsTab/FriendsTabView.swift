//
//  MyFriendsView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import ComposableArchitecture
import SwiftUI

struct FriendsTabView: View {
    @Bindable var store: StoreOf<FriendsTabCoordinator>
    
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
            case let .communityProfile(store):
                CommunityProfileView(store: store)
            }
        }
    }
}

#Preview {
    FriendsTabView(store: .init(
        initialState: FriendsTabCoordinator.State(),
        reducer: { FriendsTabCoordinator() }
    ))
}
