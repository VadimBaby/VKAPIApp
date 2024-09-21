//
//  ProfileView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 17.09.2024.
//

import ComposableArchitecture
import SwiftUI

struct UserProfileView: View {
    @Bindable var store: StoreOf<UserProfileFeature>
    
    var body: some View {
            LoadableView(
                store: store.scope(state: \.loadableView, action: \.loadableView)
            ) {
                ScrollView {
                    VStack(spacing: 15) {
                        UserProfileInfoView(
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
                            emptyStateMessage: Constants.friendsEmptyMessage,
                            action: toFriends
                        )
                        
                        CommunitiesSectionView(
                            communities: store.communities,
                            communitiesCommonCount: store.communitiesCommonCount
                        )
                        .roundedContainer(
                            isContentLoading: store.isCommunitiesLoading,
                            isContentEmpty: store.communities.isEmpty,
                            emptyStateMessage: Constants.communitiesEmptyMessage,
                            action: toCommunities
                        )
                        
                        PhotosSectionView(
                            photosSizes: store.photosSizes
                        )
                        .roundedContainer(
                            isContentLoading: store.isPhotosLoading,
                            isContentEmpty: store.photosSizes.isEmpty,
                            emptyStateMessage: Constants.photosEmptyMessage,
                            action: toPhotos
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
            .navigationTitle(store.profile.domain ?? Constants.title)
    }
}

private extension UserProfileView {
    func appearAction() {
        store.send(.onAppear)
    }
    
    func refreshAction() {
        store.send(.onRefresh)
    }
    
    func toFriends() {
        store.send(.toFriends(store.userType))
    }
    
    func toCommunities() {
        store.send(.toCommunities(store.userType))
    }
    
    func toPhotos() {
        store.send(.toPhotos(store.userType))
    }
}

fileprivate enum Constants {
    static let title = "Профиль"
    static let friendsEmptyMessage = "У вас нет друзей"
    static let communitiesEmptyMessage = "У вас нет сообществ"
    static let photosEmptyMessage = "У вас нет фото"
}

#Preview {
    UserProfileView(store: .init(
        initialState: UserProfileFeature.State(userType: .me),
        reducer: {
            UserProfileFeature()
        })
    )
}

