//
//  ServerErrorResponseMOdel.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 23.09.2024.
//

import Foundation

struct ServerErrorResponseModel: Decodable {
    let code: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "error_code"
        case message = "error_msg"
    }
}

extension ServerErrorResponseModel {
    func isSuccessCode() -> Bool {
        code == 7
    }
}
