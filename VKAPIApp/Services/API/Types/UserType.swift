//
//  UserType.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

enum UserType {
    case my, user(id: Int)
    
    var userId: String? {
        switch self {
        case .my:
            nil
        case .user(let id):
            String(id)
        }
    }
}
