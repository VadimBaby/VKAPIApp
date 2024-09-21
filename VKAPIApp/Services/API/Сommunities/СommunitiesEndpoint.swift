//
//  СommunitiesEndpoint.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import AsyncNetwork

enum CommunitiesEndpoint: RequestEndpoint {
    case getList(of: UserType, offset: Int, count: Int)
    
    var host: String {
        Consts.Base.hostURL
    }
    
    var path: String {
        "/method/groups.get"
    }
    
    var method: RequestMethod {
        .get
    }
    
    var query: RequestQuery? {
        guard case let .getList(userType, offset, count) = self else { return nil }
        
        var params: [String: String] = [:]
        
        params["access_token"] = UserStorage.shared.token.orEmpty
        
        if let id = userType.userId {
            params["user_id"] = id
        }
        
        params["extended"] = "1"
        params["fields"] = "activity,members_count"
        params["offset"] = String(offset)
        params["count"] = String(count)
        params["v"] = "5.199"
        
        return params
    }
}
