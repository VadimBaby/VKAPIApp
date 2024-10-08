//
//  CommunityProfileView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import ComposableArchitecture
import SwiftUI

struct CommunityView: View {
    @Bindable var store: StoreOf<CommunityFeature>
    
    var body: some View {
        LoadableView(store: store.scope(state: \.loadableView, action: \.loadableView)) {
            ScrollView {
                VStack {
                    ProfileInfoView(
                        avatar: store.community.displayAvatar,
                        title: store.community.name,
                        description: store.community.description,
                        infoContent: profileContent
                    )
                    .roundedContainer()
                    
                    AvatarGroupView(
                        models: store.members,
                        title: Constants.membersTitle,
                        commonCount: store.membersCommonCount
                    )
                    .roundedContainer(
                        isContentLoading: store.isMembersLoading,
                        isContentEmpty: store.members.isEmpty,
                        emptyContent: EmptyContentView(message: Constants.membersEmptyMessage)
                    )
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
        .navigationTitle(store.community.screenName)
    }
}

// MARK: - Subviews

private extension CommunityView {
    @ViewBuilder
    func profileContent() -> some View {
        Label(store.community.screenName, systemImage: "at")
        
        if let activity = store.community.activity {
            Label(activity, systemImage: "newspaper.fill")
        }
        
        if let memberCount = store.community.membersCount {
            Label("Подписчиков: \(memberCount)", systemImage: "dot.radiowaves.up.forward")
        }
    }
}

// MARK: - Functions

extension CommunityView {
    func appearAction() {
        store.send(.onAppear)
    }
    
    func refreshAction() {
        store.send(.onRefresh)
    }
}

fileprivate enum Constants {
    static let membersTitle = "Участники"
    static let membersEmptyMessage = "У группы нет участников"
}

#Preview {
    CommunityView(store: .init(
        initialState: CommunityFeature.State(community: .mock),
        reducer: { CommunityFeature() }
    ))
}
