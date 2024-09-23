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
                    ForEach(store.friends, content: listItemView)
                    
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

// MARK: - Subviews

private extension FriendsView {
    @ViewBuilder
    func listItemView(friend: User) -> some View {
        Button(action: { toProfile(id: friend.id) }) {
            ProfileListItemView(
                avatar: friend.displayAvatar,
                online: friend.online,
                onlineMobile: friend.onlineMobile,
                title: friend.displayName
            ) {
                if let city = friend.city {
                    TextInfoView(title: "Город", value: city)
                }
                
                if let displayBirthday = friend.displayBirthday {
                    TextInfoView(title: "Дата рождения", value: displayBirthday)
                }
            }
        }
    }
    
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

// MARK: - Functions

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
