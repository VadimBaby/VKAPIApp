//
//  Gender.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 11.09.2024.
//

enum Gender: Int {
    case unknown = 0
    case female
    case male
    
    var title: String {
        switch self {
        case .female:
            "Женский"
        case .male:
            "Мужской"
        case .unknown:
            "Не указан"
        }
    }
}

