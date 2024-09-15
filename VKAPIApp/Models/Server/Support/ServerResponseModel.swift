//
//  ResponseModel.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 11.09.2024.
//

import Foundation

struct ServerResponseModel<T: Decodable & Localizable>: Decodable {
    let count: Int?
    let items: [T]?
}

extension ServerResponseModel: Localizable {
    func toLocal() -> ResponseModel<T.LocalModel> {
        let items: [T.LocalModel] = self.items?.map{ $0.toLocal() } ?? []
            
        return ResponseModel(count: self.count, items: items)
    }
}
