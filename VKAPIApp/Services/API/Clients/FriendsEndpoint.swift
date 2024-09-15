//
//  FriendsEndpoint.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 11.09.2024.
//

import AsyncNetwork

enum FriendsEndpoint: RequestEndpoint {
    case getList(offset: Int, count: Int)
    
    var host: String {
        Consts.Base.hostURL
    }
    
    var path: String {
        "/method/friends.get"
    }
    
    var method: RequestMethod {
        .get
    }
    
    var query: RequestQuery? {
        guard case let .getList(offset, count) = self else { return nil }
        
        var params: [String: String] = [:]
        
        params["access_token"] = UserStorage.shared.token.orEmpty
        params["fields"] = "bdate,city,country,last_seen,online,photo_100,sex"
        params["offset"] = String(offset)
        params["count"] = String(count)
        params["v"] = "5.199"
        
        return params
    }
}
