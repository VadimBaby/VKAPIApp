//
//  СommunitiesEndpoint.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import AsyncNetwork

enum CommunitiesEndpoint: RequestEndpoint {
    case getList(of: UserType, offset: Int, count: Int)
    case getMembers(by: Int, offset: Int, count: Int)
    
    var host: String {
        Consts.Base.hostURL
    }
    
    var path: String {
        switch self {
        case .getList:
            "/method/groups.get"
        case .getMembers:
            "/method/groups.getMembers"
        }
    }
    
    var method: RequestMethod {
        .get
    }
    
    var query: RequestQuery? {
        var params: [String: String] = [:]
        
        params["access_token"] = UserStorage.shared.token.orEmpty
        
        switch self {
        case let .getList(userType, offset, count):
            if let id = userType.userId {
                params["user_id"] = id
            }
            
            params["extended"] = "1"
            params["fields"] = "activity,members_count,description"
            configurePaginationValues(in: &params, offset: offset, count: count)
            
        case let .getMembers(communityId, offset, count):
            params["group_id"] = String(communityId)
            params["fields"] = "photo_200,photo_100,photo_50"
            configurePaginationValues(in: &params, offset: offset, count: count)
        }
        
        params["v"] = "5.199"
        
        return params
    }
}

private extension CommunitiesEndpoint {
    func configurePaginationValues(in params: inout [String: String], offset: Int, count: Int) {
        params["offset"] = String(offset)
        params["count"] = String(count)
    }
}
