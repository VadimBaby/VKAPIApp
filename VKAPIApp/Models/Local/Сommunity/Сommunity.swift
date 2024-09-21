//
//  Group.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import Foundation

struct Group: Identifiable {
    let id: Int
    let membersCount: Int?
    let activity: String?
    let name: String
    let screenName: String
    let photoSmall: URL?
    let photo: URL?
    let photoBig: URL?
}

extension Group {
    init(from serverModel: ServerGroupModel) {
        self.init(
            id: serverModel.id.orRandomId,
            membersCount: serverModel.membersCount,
            activity: serverModel.activity,
            name: serverModel.name.orEmpty,
            screenName: serverModel.screenName.orEmpty,
            photoSmall: URL(string: serverModel.photoSmall.orEmpty),
            photo: URL(string: serverModel.photo.orEmpty),
            photoBig: URL(string: serverModel.photoBig.orEmpty)
        )
    }
}
