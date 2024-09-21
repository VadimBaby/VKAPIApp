//
//  ResponseModel.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 14.09.2024.
//

import Foundation

struct ArrayInnerResponseModel<T> {
    let count: Int?
    let items: [T]
}
