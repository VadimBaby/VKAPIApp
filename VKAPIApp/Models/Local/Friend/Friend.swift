//
//  Friend.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 11.09.2024.
//

import Foundation

struct Friend: Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let birthDate: DateComponents? 
    let city: String?
    let lastSeen: LastSeen? 
    let photo: URL?
    let online: Bool
    let onlineMobile: Bool?  
    let gender: Gender?
}

extension Friend {
    var displayName: String {
        firstName + " " + lastName
    }
    
    func bithdayString() -> String? {
        guard let birthDate = self.birthDate,
              let date = Calendar.current.date(from: birthDate) else { return nil }
        
        if birthDate.year.isNotNil {
            return DateFormatters.dayAndMonthAndYearFormatter.string(from: date)
        } else {
            return DateFormatters.dayAndMonthFormatter.string(from: date)
        }
    }
}

// MARK: - Inits

extension Friend {
    init(from serverModel: ServerFriendModel) {
        self.init(
            id: serverModel.id.orRandomId,
            firstName: serverModel.firstName.orEmpty,
            lastName: serverModel.lastName.orEmpty,
            birthDate: serverModel.birthDate?.toDateComponents(),
            city: serverModel.city?.title,
            lastSeen: serverModel.lastSeen?.toLocal(),
            photo: URL(string: serverModel.photo.orEmpty),
            online: serverModel.online?.bool() ?? false,
            onlineMobile: serverModel.onlineMobile?.bool(),
            gender: .init(rawValue: serverModel.sex.orZero)
        )
    }
}

// MARK: - Mock Data

extension Friend {
    static let mock: Friend = .init(
        id: 270063634,
        firstName: "Алексей",
        lastName: "Никулин",
        birthDate: "27.4".toDateComponents(),
        city: "Новосибирск",
        lastSeen: .init(date: Date(timeIntervalSince1970: 1725931616), plarfrom: .iPhone),
        photo: .init(string: "https://clck.ru/3DEnoW"),
        online: true,
        onlineMobile: false,
        gender: .male
    )
}

// MARK: Equatable

extension Friend: Equatable {
    static func == (lhs: Friend, rhs: Friend) -> Bool {
        lhs.id == rhs.id
    }
}
