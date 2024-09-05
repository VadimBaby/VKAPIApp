//
//  AuthURLBuilder.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 04.09.2024.
//

import Foundation

final class AuthURLBuilder {
    static let current = AuthURLBuilder()
    
    private init() {}
    
    var url: URL? {
        guard var components = URLComponents(string: Consts.Auth.vkURL) else { return nil }
        
        let items = [
            URLQueryItem(name: Consts.Auth.clientIDKey, value: Consts.Auth.clientIDValue),
            URLQueryItem(name: Consts.Auth.redirectUriKey, value: Consts.Auth.redirectUriValue),
            URLQueryItem(name: Consts.Auth.scopeKey, value: Consts.Auth.scopeValue),
            URLQueryItem(name: Consts.Auth.displayKey, value: Consts.Auth.displayValue),
            URLQueryItem(name: Consts.Auth.responseTypeKey, value: Consts.Auth.responseTypeValue),
        ]
        
        components.queryItems = items
        
        return components.url
    }
}
