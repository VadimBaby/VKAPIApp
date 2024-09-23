//
//  Photographable.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//
import Foundation

protocol Avatarable {
    var avatarSmall: URL? { get }
    var avatar: URL? { get }
    var avatarBig: URL? { get }
}

extension Avatarable {
    var displayAvatar: URL? {
        return avatar ?? avatarBig ?? avatarSmall ?? nil
    }
}
