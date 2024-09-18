//
//  ServerUserLastSeenModel.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 14.09.2024.
//

import Foundation

struct ServerUserLastSeenModel: Decodable {
    let plarform: Int?
    let time: Int?
}

extension ServerUserLastSeenModel: Localizable {
    func toLocal() -> LastSeen? {
        .init(from: self)
    }
}


