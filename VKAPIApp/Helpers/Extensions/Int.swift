//
//  Int.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 14.09.2024.
//

import Foundation

extension Int {
    func dateFromUnix() -> Date {
        Date(timeIntervalSince1970: Double(self))
    }
    
    func bool() -> Bool {
        self == 1
    }
}
