//
//  UserPhoto.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 17.09.2024.
//

import Foundation

struct Photo: Identifiable {
    let id: Int
    let date: Date?
    let sizes: [PhotoSize]
}

extension Photo {
    init?(from serverModel: ServerPhotoModel) {
        guard let sizes = serverModel.sizes else { return nil }
        
        let fillSizes = sizes.compactMap{ PhotoSize(from: $0) }
        
        guard !fillSizes.isEmpty else { return nil }
        
        self.id = serverModel.id
        self.sizes = fillSizes
        
        if let unixDate = serverModel.unixDate {
            self.date = unixDate.dateFromUnix()
        } else {
            self.date = nil
        }
    }
}
