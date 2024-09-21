//
//  ProfileEndpoint.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 17.09.2024.
//

import AsyncNetwork

enum ProfileEndpoint: RequestEndpoint {
    case getProfile(of: UserType)
    case getPhotos(of: UserType, album: AlbumIndentifier?)
    
    var host: String {
        Consts.Base.hostURL
    }
    
    var path: String {
        switch self {
        case .getProfile:
            "/method/users.get"
        case .getPhotos:
            "/method/photos.get"
        }
    }
    
    var method: RequestMethod {
        .get
    }
    
    var query: RequestQuery? {
        var params: [String : String] = [:]
        
        switch self {
        case .getProfile(let userType):
            params["fields"] = "bdate,domain,followers_count,photo_50,photo_200,sex,last_seen,online"
            
            if let userId = userType.userId {
                params["user_ids"] = userId
            }
        case .getPhotos(of: let userType, album: let indentifier):
            params["album_id"] = (indentifier ?? .profile).queryParam
            
            if let userId = userType.userId {
                params["owner_id"] = userId
            }
        }
        
        params["access_token"] = UserStorage.shared.token.orEmpty
        params["v"] = "5.199"
        
        return params
    }
}

enum AlbumIndentifier {
    case id(Int)
    case wall
    case saved
    case profile
    
    var queryParam: String {
        switch self {
        case .id(let id):
            String(id)
        case .wall:
            "wall"
        case .saved:
            "saved"
        case .profile:
            "profile"
        }
    }
}

enum UserType {
    case my, user(id: Int)
    
    var userId: String? {
        switch self {
        case .my:
            nil
        case .user(let id):
            String(id)
        }
    }
}
