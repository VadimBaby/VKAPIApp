//
//  Group.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import Foundation

struct Community: Identifiable, Equatable, Avatarable {
    let id: Int
    let description: String?
    let membersCount: Int?
    let activity: String?
    let name: String
    let screenName: String
    let avatarSmall: URL?
    let avatar: URL?
    let avatarBig: URL?
}

extension Community {
    init(from serverModel: ServerCommunityModel) {
        self.init(
            id: serverModel.id.orRandomId,
            description: serverModel.description,
            membersCount: serverModel.membersCount,
            activity: serverModel.activity,
            name: serverModel.name.orEmpty,
            screenName: serverModel.screenName.orEmpty,
            avatarSmall: URL(string: serverModel.photoSmall.orEmpty),
            avatar: URL(string: serverModel.photo.orEmpty),
            avatarBig: URL(string: serverModel.photoBig.orEmpty)
        )
    }
}

// MARK: - Mock Data

extension Community {
    static var mock: Community = .init(
        id: 1,
        description: "Описание",
        membersCount: 100,
        activity: "News",
        name: "News Public",
        screenName: "news_public",
        avatarSmall: URL(string: ""),
        avatar: URL(string: "https://clck.ru/3DRS8L"),
        avatarBig: URL(string: "")
    )
}
