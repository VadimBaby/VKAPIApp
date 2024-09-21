//
//  FriendsListView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 11.09.2024.
//

import SwiftUI
import ComposableArchitecture

struct FriendsView: View {
    @Bindable var store: StoreOf<FriendsFeature>
    
    var body: some View {
        LoadableView(
            store: store.scope(
                state: \.loadableView,
                action: \.loadableView
            )
        ) {
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(store.friends) { friend in
                        Button(action: { toProfile(id: friend.id) }) {
                            FriendsListItemView(friend: friend)
                        }
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeAreaBackground(.systemGray6)
        .onAppear(perform: appearAction)
        .navigationTitle("Друзья")
    }
}

private extension FriendsView {
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

private extension FriendsView {
    func appearAction() {
        store.send(.onAppear)
    }
    
    func refreshAction() {
        store.send(.onRefresh)
    }
    
    func paginationAction() {
        store.send(.onPaginationLoad)
    }
    
    func toProfile(id: Int) {
        store.send(.toProfile(.id(id)))
    }
}

#Preview {
    FriendsView(store: .init(
        initialState: FriendsFeature.State(userType: .me),
        reducer: { FriendsFeature() }
    ))
}
