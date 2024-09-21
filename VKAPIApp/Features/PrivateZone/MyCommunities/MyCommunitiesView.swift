//
//  MyCommunitiesView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import ComposableArchitecture
import SwiftUI

struct MyCommunitiesView: View {
    @Bindable var store: StoreOf<MyCommunitiesFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            CommunitiesView(store: store.scope(state: \.communities, action: \.communities))
        } destination: { store in
            switch store.case {
            case let .communityProfile(store):
                CommunityProfileView(store: store)
            }
        }
    }
}

#Preview {
    MyCommunitiesView(store: .init(
        initialState: MyCommunitiesFeature.State(),
        reducer: { MyCommunitiesFeature() }
    ))
}
