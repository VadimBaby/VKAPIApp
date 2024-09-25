//
//  UserType.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

enum UserType: Equatable {
    case me, id(Int)
    
    var userId: String? {
        switch self {
        case .id(let id):
            String(id)
        case .me:
            nil
        }
    }
}
