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
    
    var getList: (_ of: UserType,_ offset: Int, _ count: Int) async throws -> ArrayInnerResponseModel<User>
}


extension FriendsAPIClient: DependencyKey {
    static var liveValue = FriendsAPIClient { userType, offset, count in
        let endpoint: FriendsEndpoint = .getList(of: userType, offset: offset, count: count)
        
        let response = try await networkClient.sendRequest(with: endpoint)
            .decode(
                to: ServerArrayInnerResponseModel<ServerUserModel>.self,
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
