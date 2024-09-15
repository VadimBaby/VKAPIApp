//
//  ServerFriendModel.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 11.09.2024.
//

import Foundation

struct ServerFriendModel: Decodable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let birthDate: String?
    let city: ServerFriendCityModel?
    let lastSeen: ServerFriendLastSeenModel?
    let photo: String?
    let online: Int?
    let onlineMobile: Int?
    let sex: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case birthDate = "bdate"
        case city
        case lastSeen = "last_seen"
        case photo = "photo_100"
        case online
        case onlineMobile = "online_mobile"
        case sex
    }
}

extension ServerFriendModel: Localizable {
    func toLocal() -> Friend {
        .init(from: self)
    }
}
