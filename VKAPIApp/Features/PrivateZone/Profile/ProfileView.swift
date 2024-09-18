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
        NavigationStack {
            LoadableView(
                store: store.scope(state: \.loadableView, action: \.loadableView)
            ) {
                ScrollView {
                    VStack(spacing: 15) {
                        ProfileSectionView(
                            profile: store.profile,
                            isProfileLoading: store.isProfileLoading
                        )
                        FriendsSectionView(
                            friends: store.friends,
                            friendsCommonCount: store.friendsCommonCount,
                            isFriendsLoading: store.isFriendsLoading
                        )
                        PhotosSectionView(
                            photosSizes: store.photosSizes,
                            isPhotoLoading: store.isPhotosLoading)
                        
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
            .onAppear(perform: appearAction)
            .navigationTitle(Constants.title)
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
}

fileprivate enum Constants {
    static let title = "Профиль"
}

#Preview {
    ProfileView(store: .init(
        initialState: ProfileFeature.State(),
        reducer: {
            ProfileFeature()
        })
    )
}

