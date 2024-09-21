//
//  Photographable.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//
import Foundation

protocol Photographable {
    var photoSmall: URL? { get }
    var photo: URL? { get }
    var photoBig: URL? { get }
}

extension Photographable {
    var displayPhoto: URL? {
        return photo ?? photoBig ?? photoSmall ?? nil
    }
}
