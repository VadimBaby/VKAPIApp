//
//  PhotoSize.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 18.09.2024.
//

import Foundation

struct PhotoSize: Identifiable, Equatable {
    let id = UUID()
    let height: Double
    let width: Double
    let type: String?
    let url: URL?
    
    var size: CGSize {
        .init(width: width, height: height)
    }
    
    var isHorizontal: Bool {
        width > height
    }
    
    static let mock: Self = .init(
        height: 160,
        width: 130,
        type: nil,
        url: .init(string: "https://clck.ru/3DEnoW")
    )
}

extension PhotoSize {
    init?(from serverModel: ServerPhotoSize) {
        guard let width = serverModel.width,
              let height = serverModel.height,
              let url = URL(string: serverModel.url.orEmpty) else { return nil }
        
        self.width = width
        self.height = height
        self.type = serverModel.type
        self.url = url
    }
}
