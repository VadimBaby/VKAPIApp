//
//  LastSeen.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 14.09.2024.
//

import Foundation

struct LastSeen {
    let date: Date?
    let plarfrom: Platform?
}

extension LastSeen {
    init(from serverModel: ServerUserLastSeenModel) {
        self.init(
            date: serverModel.time?.dateFromUnix(),
            plarfrom: .init(rawValue: serverModel.plarform.orZero)
        )
    }
}
