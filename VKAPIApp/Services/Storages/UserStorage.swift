//
//  UserStorage.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 04.09.2024.
//

import Foundation

enum UserStorageKey: String {
    case token, userID
}

struct UserStorage {
    static var shared = UserStorage()
    
    private let defaults = UserDefaults()
    
    private init() {}
    
    var token: String? {
        get {
            string(forKey: .token)
        }
        set {
            setValue(newValue, forKey: .token)
        }
    }
    
    var userID: String? {
        get {
            string(forKey: .userID)
        }
        set {
            setValue(newValue, forKey: .userID)
        }
    }
}

private extension UserStorage {
    func setValue(_ value: Any?, forKey key: UserStorageKey) {
        defaults.setValue(value, forKey: key.rawValue)
    }
    
    func string(forKey key: UserStorageKey) -> String? {
        defaults.string(forKey: key.rawValue)
    }
}
