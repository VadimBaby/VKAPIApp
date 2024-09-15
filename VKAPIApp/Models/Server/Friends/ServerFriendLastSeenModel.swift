//
//  ServerFriendLastSeenModel.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 14.09.2024.
//

import Foundation

struct ServerFriendLastSeenModel: Decodable {
    let plarform: Int?
    let time: Int?
}

extension ServerFriendLastSeenModel: Localizable {
    func toLocal() -> LastSeen {
        .init(from: self)
    }
}


