//
//  ResponseModel.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 11.09.2024.
//

import Foundation

struct ServerArrayInnerResponseModel<T: Decodable & Localizable>: Decodable {
    let count: Int?
    let items: [T]?
}

extension ServerArrayInnerResponseModel {
    func toLocal() -> ArrayInnerResponseModel<T.LocalModel> {
        let items: [T.LocalModel] = self.items?.compactMap{ $0.toLocal() } ?? []
            
        return ArrayInnerResponseModel(count: self.count, items: items)
    }
}
