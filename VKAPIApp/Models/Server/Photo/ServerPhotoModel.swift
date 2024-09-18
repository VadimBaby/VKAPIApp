//
//  ServerPhotoModel.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 17.09.2024.
//

import Foundation

struct ServerPhotoModel: Decodable {
    let id: Int
    let unixDate: Int?
    let sizes: [ServerPhotoSize]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case unixDate = "date"
        case sizes
    }
}


extension ServerPhotoModel: Localizable {
    func toLocal() -> Photo? {
        .init(from: self)
    }
}

struct ServerPhotoSize: Decodable {
    let height: Double?
    let width: Double?
    let type: String?
    let url: String?
}
