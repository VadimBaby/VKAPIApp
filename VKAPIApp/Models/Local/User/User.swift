//
//  User.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 11.09.2024.
//

import Foundation

struct User: Identifiable, Avatarable {
    let id: Int
    let firstName: String
    let lastName: String
    let birthDate: DateComponents? 
    let city: String?
    let lastSeen: LastSeen?
    let avatarSmall: URL?
    let avatar: URL?
    let avatarBig: URL?
    let online: Bool
    let onlineMobile: Bool?  
    let gender: Gender?
    let domain: String?
    let followersCount: Int?
}

extension User {
    var displayName: String {
        firstName + " " + lastName
    }
    
    var displayBirthday: String? {
        guard let birthDate = self.birthDate,
              let date = Calendar.current.date(from: birthDate) else { return nil }
        
        if birthDate.year.isNotNil {
            return DateFormatters.dayAndMonthAndYearFormatter.string(from: date) + "г"
        } else {
            return DateFormatters.dayAndMonthFormatter.string(from: date)
        }
    }
}

// MARK: - Inits

extension User {
    init(from serverModel: ServerUserModel) {
        self.init(
            id: serverModel.id.orRandomId,
            firstName: serverModel.firstName.orEmpty,
            lastName: serverModel.lastName.orEmpty,
            birthDate: serverModel.birthDate?.toDateComponents(),
            city: serverModel.city?.title,
            lastSeen: serverModel.lastSeen?.toLocal(),
            avatarSmall: URL(string: serverModel.photoSmall.orEmpty),
            avatar: URL(string: serverModel.photo.orEmpty),
            avatarBig: URL(string: serverModel.photoBig.orEmpty),
            online: serverModel.online?.bool() ?? false,
            onlineMobile: serverModel.onlineMobile?.bool(),
            gender: .init(rawValue: serverModel.sex.orZero),
            domain: serverModel.domain,
            followersCount: serverModel.followersCount
        )
    }
}

// MARK: - Mock Data

extension User {
    static let mock: User = .init(
        id: 270063634,
        firstName: "Алексей",
        lastName: "Никулин",
        birthDate: "27.4".toDateComponents(),
        city: "Новосибирск",
        lastSeen: .init(date: Date(timeIntervalSince1970: 1725931616), plarfrom: .iPhone),
        avatarSmall: .init(string: "https://clck.ru/3DEnoW"),
        avatar: .init(string: "https://clck.ru/3DEnoW"),
        avatarBig: .init(string: "https://clck.ru/3DEnoW"),
        online: true,
        onlineMobile: false,
        gender: .male,
        domain: "batty_cooper",
        followersCount: 30
    )
    
    static let empty: User = .init(
        id: 0,
        firstName: "",
        lastName: "",
        birthDate: nil,
        city: nil,
        lastSeen: nil,
        avatarSmall: nil,
        avatar: nil,
        avatarBig: nil,
        online: false,
        onlineMobile: nil,
        gender: nil,
        domain: nil,
        followersCount: nil
    )
}

// MARK: Equatable

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
