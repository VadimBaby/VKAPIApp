//
//  FriendsAPIClient.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 11.09.2024.
//

import AsyncNetwork
import ComposableArchitecture

struct FriendsAPIClient {
    @Dependency(\.networkClient) private static var networkClient
    
    var getList: (_ offset: Int, _ count: Int) async throws -> ResponseModel<User>
}


extension FriendsAPIClient: DependencyKey {
    static var liveValue = FriendsAPIClient { offset, count in
        let endpoint: FriendsEndpoint = .getList(offset: offset, count: count)
        
        let response = try await networkClient.sendRequest(with: endpoint)
            .decode(
                to: ServerResponseModel<ServerUserModel>.self,
                at: "response"
            )
        
        return response.toLocal()
    }
}

extension DependencyValues {
    var friendsClient: FriendsAPIClient {
        get { self[FriendsAPIClient.self] }
        set { self[FriendsAPIClient.self] = newValue }
    }
}
