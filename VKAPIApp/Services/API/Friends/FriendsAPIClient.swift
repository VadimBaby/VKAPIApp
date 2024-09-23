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
        
        let data = try await networkClient.sendRequest(with: endpoint)
        
        if let response = try? data.decode(
            to: ServerArrayInnerResponseModel<ServerUserModel>.self,
            at: "response"
        ) {
            return response.toLocal()
        }
        
        if let errorResponse = try? data.decode(to: ServerErrorResponseModel.self, at: "error"), errorResponse.isSuccessCode() {
            return .init(count: nil, items: [])
        }
        
        throw NetworkError.decode(nil)
    }
}

extension DependencyValues {
    var friendsClient: FriendsAPIClient {
        get { self[FriendsAPIClient.self] }
        set { self[FriendsAPIClient.self] = newValue }
    }
}
