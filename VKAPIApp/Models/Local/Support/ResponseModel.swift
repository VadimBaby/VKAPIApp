//
//  ResponseModel.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 14.09.2024.
//

import Foundation

struct ResponseModel<T> {
    let count: Int?
    let items: [T]
}
