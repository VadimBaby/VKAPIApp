//
//  CommunitiesAPIClient.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import AsyncNetwork
import ComposableArchitecture

struct CommunitiesAPIClient {
    @Dependency(\.networkClient) private static var networkClient
    
    var getList: (_ of: UserType,_ offset: Int, _ count: Int) async throws -> ArrayInnerResponseModel<Community>
    var getMembers: (_ of: Int,_ offset: Int, _ count: Int) async throws -> ArrayInnerResponseModel<User>
}


extension CommunitiesAPIClient: DependencyKey {
    static var liveValue = CommunitiesAPIClient(
        getList: { userType, offset, count in
            let endpoint: CommunitiesEndpoint = .getList(of: userType, offset: offset, count: count)
            
            let response = try await networkClient.sendRequest(with: endpoint)
                .decode(
                    to: ServerArrayInnerResponseModel<ServerCommunityModel>.self,
                    at: "response"
                )
            
            return response.toLocal()
        },
        getMembers: { communityId, offset, count in
            let endpoint: CommunitiesEndpoint = .getMembers(of: communityId, offset: offset, count: count)
            
            let response = try await networkClient.sendRequest(with: endpoint)
                .decode(
                    to: ServerArrayInnerResponseModel<ServerUserModel>.self,
                    at: "response"
                )
            
            return response.toLocal()
        })
}

extension DependencyValues {
    var communitiesClient: CommunitiesAPIClient {
        get { self[CommunitiesAPIClient.self] }
        set { self[CommunitiesAPIClient.self] = newValue }
    }
}
