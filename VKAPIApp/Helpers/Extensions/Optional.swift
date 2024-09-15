//
//  Optional.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 11.09.2024.
//

import Foundation

extension Optional {
    var isNil: Bool {
        self == nil
    }
    
    var isNotNil: Bool {
        self != nil
    }
}

// MARK: - String

extension Optional where Wrapped == String {
    var orEmpty: String {
        self ?? ""
    }
}

// MARK: - Int

extension Optional where Wrapped == Int {
    var orZero: Int {
        self ?? .zero
    }
    
    var orRandomId: Int {
        self ?? UUID().hashValue
    }
}
