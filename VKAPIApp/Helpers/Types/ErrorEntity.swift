//
//  ErrorEntity.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 14.09.2024.
//

import Foundation

struct ErrorEntity: Identifiable, Equatable {
    let id = UUID().uuidString
    let description: String
    
    init(from error: Error) {
        self.description = error.localizedDescription
    }
}
