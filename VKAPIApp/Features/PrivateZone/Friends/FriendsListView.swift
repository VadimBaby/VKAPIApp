//
//  FriendsListView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 11.09.2024.
//

import SwiftUI
import ComposableArchitecture

struct FriendsListView: View {
    @Bindable var store: StoreOf<FriendsListFeature>
    
    var body: some View {
        NavigationStack {
            LoadableView(
                store: store.scope(
                    state: \.loadableView,
                    action: \.loadableView
                )
            ) {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(store.friends) { friend in
                            FriendsListItemView(friend: friend)
                        }
                        
                        if store.friends.count < store.maxFriendsCount {
                            paginationView
                        }
                    }
                    .padding()
                }
                .refreshable {
                    Task {
                        try await Task.sleep(for: .seconds(0.15))
                        refreshAction()
                    }
                }
            }
            .navigationTitle("Друзья")
            .onAppear(perform: appearAction)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeAreaBackground(.systemGray6)
        }
    }
}

private extension FriendsListView {
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

private extension FriendsListView {
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

#Preview {
    FriendsListView(store: .init(
        initialState: FriendsListFeature.State(),
        reducer: { FriendsListFeature() }
    ))
}
