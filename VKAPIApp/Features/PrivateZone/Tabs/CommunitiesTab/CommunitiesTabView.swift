//
//  MyCommunitiesView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import ComposableArchitecture
import SwiftUI

struct CommunitiesTabView: View {
    @Bindable var store: StoreOf<CommunitiesTabCoordinator>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            CommunitiesView(store: store.scope(state: \.communities, action: \.communities))
        } destination: { store in
            switch store.case {
            case let .communityProfile(store):
                CommunityView(store: store)
            }
        }
    }
}

#Preview {
    CommunitiesTabView(store: .init(
        initialState: CommunitiesTabCoordinator.State(),
        reducer: { CommunitiesTabCoordinator() }
    ))
}
