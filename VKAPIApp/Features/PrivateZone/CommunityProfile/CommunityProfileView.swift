//
//  CommunityProfileView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import ComposableArchitecture
import SwiftUI

struct CommunityProfileView: View {
    @Bindable var store: StoreOf<CommunityProfileFeature>
    
    var body: some View {
        LoadableView(store: store.scope(state: \.loadableView, action: \.loadableView)) {
            ScrollView {
                VStack {
                    CommunityProfileInfoView(community: store.community)
                        .roundedContainer()
                    
                    FriendsSectionView(
                        friends: store.members,
                        friendsCommonCount: store.membersCommonCount
                    )
                    .roundedContainer(
                        isContentLoading: store.isMembersLoading,
                        isContentEmpty: store.members.isEmpty,
                        emptyStateMessage: Constants.membersEmptyMessage
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

extension CommunityProfileView {
    func appearAction() {
        store.send(.onAppear)
    }
    
    func refreshAction() {
        store.send(.onRefresh)
    }
}

fileprivate enum Constants {
    static let membersEmptyMessage = "У группы нет участников"
}

#Preview {
    CommunityProfileView(store: .init(
        initialState: CommunityProfileFeature.State(community: .mock),
        reducer: { CommunityProfileFeature() }
    ))
}
