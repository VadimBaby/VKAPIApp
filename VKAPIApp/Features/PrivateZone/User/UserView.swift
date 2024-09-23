//
//  ProfileView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 17.09.2024.
//

import ComposableArchitecture
import SwiftUI

struct UserView: View {
    @Bindable var store: StoreOf<UserFeature>
    
    var body: some View {
            LoadableView(
                store: store.scope(state: \.loadableView, action: \.loadableView)
            ) {
                ScrollView {
                    VStack(spacing: 15) {
                        ProfileInfoView(
                            avatar: store.profile.displayAvatar,
                            title: store.profile.displayName,
                            infoContent: profileContent
                        )
                        .roundedContainer(isContentLoading: store.isProfileLoading)
                        
                        AvatarGroupView(
                            models: store.friends,
                            title: Constants.friendsTitle,
                            commonCount: store.friendsCommonCount
                        )
                        .roundedContainer(
                            isContentLoading: store.isFriendsLoading,
                            isContentEmpty: store.friends.isEmpty,
                            emptyStateMessage: Constants.friendsEmptyMessage,
                            action: toFriends
                        )
                        
                        AvatarGroupView(
                            models: store.communities,
                            title: Constants.communitiesTitle,
                            commonCount: store.communitiesCommonCount
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
            .navigationTitle(store.profile.domain ?? Constants.navigationTitle)
    }
}

// MARK: - Subviews

private extension UserView {
    @ViewBuilder
    func profileContent() -> some View {
        let profile = store.profile
        
        if let domain = profile.domain {
            Label(domain, systemImage: "at")
        }
        
        if let gender = profile.gender {
            Label("Пол: \(gender.title)", systemImage: "person.fill")
        }
        
        if let bithday = profile.displayBirthday {
            Label("День рождения: \(bithday)", systemImage: "gift.fill")
        }
        
        if let city = profile.city {
            Label("Город: \(city)", systemImage: "house.fill")
        }
        
        if let followers = profile.followersCount {
            Label("Подписчиков: \(followers)", systemImage: "dot.radiowaves.up.forward")
        }
    }
}

// MARK: - Functions

private extension UserView {
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
    // MARK: - Titles
    static let friendsTitle = "Друзья"
    static let communitiesTitle = "Сообщества"
    static let navigationTitle = "Профиль"
    
    // MARK: - Empty Messages
    static let friendsEmptyMessage = "У вас нет друзей"
    static let communitiesEmptyMessage = "У вас нет сообществ"
    static let photosEmptyMessage = "У вас нет фото"
}

#Preview {
    UserView(store: .init(
        initialState: UserFeature.State(userType: .me),
        reducer: {
            UserFeature()
        })
    )
}

