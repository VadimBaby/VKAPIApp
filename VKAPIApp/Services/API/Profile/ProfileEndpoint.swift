//
//  ProfileEndpoint.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 17.09.2024.
//

import AsyncNetwork

enum ProfileEndpoint: RequestEndpoint {
    case getMyProfile
    case getPhotos(AlbumIndentifier?)
    
    var host: String {
        Consts.Base.hostURL
    }
    
    var path: String {
        switch self {
        case .getMyProfile:
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
        case .getMyProfile:
            params["fields"] = "bdate,domain,followers_count,photo_50,photo_200,sex,last_seen,online"
        case .getPhotos(let indentifier):
            params["album_id"] = (indentifier ?? .profile).queryParam
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
