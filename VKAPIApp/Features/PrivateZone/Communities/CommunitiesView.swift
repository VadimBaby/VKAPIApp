//
//  CommunitiesView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import ComposableArchitecture
import SwiftUI

struct CommunitiesView: View {
    @Bindable var store: StoreOf<CommunitiesFeature>
    
    var body: some View {
        LoadableView(store: store.scope(state: \.loadableView, action: \.loadableView)) {
            ScrollView {
                LazyVStack {
                    ForEach(store.communities) { community in
                        Button(action: { toCommunityProfileAction(community: community) }) {
                            CommunitiesListItemView(community: community)
                        }
                    }
                    
                    if store.communities.count < store.maxCommunitiesCount {
                        paginationView
                    }
                }
                .padding()
            }
            .refreshable {
                try? await Task.sleep(for: .seconds(1))
                refreshAction()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeAreaBackground(.systemGray6)
        .onFirstAppear(perform: appearAction)
        .navigationTitle(Constants.navigationTitle)
    }
}

extension CommunitiesView {
    func toCommunityProfileAction(community: Community) {
        store.send(.toCommunityProfile(community))
    }
}

private extension CommunitiesView {
    @ViewBuilder
    var paginationView: some View {
        if store.isPaginationLoading {
            ProgressView()
        } else {
            Color.clear
                .frame(height: 1)
                .onAppear(perform: paginationAction)
        }
    }
}

private extension CommunitiesView {
    func appearAction() {
        store.send(.onAppear)
    }
    
    func refreshAction() {
        store.send(.onRefresh)
    }
    
    func paginationAction() {
        store.send(.onPaginationLoad)
    }
}

fileprivate enum Constants {
    static let navigationTitle = "Сообщества"
}

#Preview {
    NavigationStack {
        CommunitiesView(store: .init(
            initialState: CommunitiesFeature.State(userType: .me),
            reducer: { CommunitiesFeature() }))
    }
}
