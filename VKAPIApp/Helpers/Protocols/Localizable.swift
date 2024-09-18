//
//  Localizable.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 14.09.2024.
//

import Foundation

protocol Localizable {
    associatedtype LocalModel
    
    func toLocal() -> LocalModel?
}
