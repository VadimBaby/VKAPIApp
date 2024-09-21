//
//  Text.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import SwiftUI

extension Text {
    init<T: BinaryInteger>(_ number: T) {
        self.init(String(number))
    }
}
