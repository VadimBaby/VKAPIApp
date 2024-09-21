//
//  ServerGroupModel.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import Foundation
import SwiftUI

struct ServerCommunityModel: Decodable {
    let id: Int?
    let membersCount: Int?
    let activity: String?
    let name: String?
    let screenName: String?
    let photoSmall: String?
    let photo: String?
    let photoBig: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case membersCount = "members_count"
        case activity
        case name
        case screenName = "screen_name"
        case photoSmall = "photo_50"
        case photo = "photo_100"
        case photoBig = "photo_200"
    }
}

extension ServerCommunityModel: Localizable {
    func toLocal() -> Community? {
        .init(from: self)
    }
}
