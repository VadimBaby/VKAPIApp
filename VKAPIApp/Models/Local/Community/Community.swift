//
//  Group.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import Foundation

struct Community: Identifiable, Equatable {
    let id: Int
    let membersCount: Int?
    let activity: String?
    let name: String
    let screenName: String
    let photoSmall: URL?
    let photo: URL?
    let photoBig: URL?
    
    var displayPhoto: URL? {
        return photo ?? photoBig ?? photoSmall ?? nil
    }
}

extension Community {
    init(from serverModel: ServerCommunityModel) {
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

// MARK: - Mock Data

extension Community {
    static var mock: Community = .init(
        id: 1,
        membersCount: 100,
        activity: "News",
        name: "News Public",
        screenName: "news_public",
        photoSmall: URL(string: ""),
        photo: URL(string: "https://clck.ru/3DRS8L"),
        photoBig: URL(string: "")
    )
}
