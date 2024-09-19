//
//  ProfileView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 17.09.2024.
//

import ComposableArchitecture
import SwiftUI

struct ProfileView: View {
    
    @Bindable var store: StoreOf<ProfileFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            LoadableView(
                store: store.scope(state: \.loadableView, action: \.loadableView)
            ) {
                ScrollView {
                    VStack(spacing: 15) {
                        ProfileSectionView(
                            profile: store.profile
                        )
                        .roundedContainer(isContentLoading: store.isProfileLoading)
                        
                        FriendsSectionView(
                            friends: store.friends,
                            friendsCommonCount: store.friendsCommonCount
                        )
                        .roundedContainer(
                            isContentLoading: store.isFriendsLoading,
                            isContentEmpty: store.friends.isEmpty,
                            emptyStateMessage: Constants.friendsEmptyMessage
                        )
                        
                        PhotosSectionView(
                            photosSizes: store.photosSizes
                        )
                        .roundedContainer(
                            isContentLoading: store.isPhotosLoading,
                            isContentEmpty: store.photosSizes.isEmpty,
                            emptyStateMessage: Constants.photosEmptyMessage,
                            action: showPhotos
                        )
                        
                    }
                    .fontWeight(.medium)
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
            .navigationTitle(Constants.title)
        } destination: { store in
            switch store.case {
            case let .photos(store):
                PhotosView(store: store)
            }
        }
    }
}

private extension ProfileView {
    func appearAction() {
        store.send(.onAppear)
    }
    
    func refreshAction() {
        store.send(.onRefresh)
    }
    
    func showPhotos() {
        store.send(.showPhotos)
    }
}

fileprivate enum Constants {
    static let title = "Профиль"
    static let friendsEmptyMessage = "У вас нет друзей"
    static let photosEmptyMessage = "У вас нет фото"
}

#Preview {
    ProfileView(store: .init(
        initialState: ProfileFeature.State(),
        reducer: {
            ProfileFeature()
        })
    )
}

