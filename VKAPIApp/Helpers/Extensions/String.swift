//
//  String.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 14.09.2024.
//

import Foundation

extension String {
    func toDateComponents() -> DateComponents? {
        if let date = DateFormatters.vkDateWithYearFormatter.date(from: self) {
            return Calendar.current.dateComponents([.day, .month, .year], from: date)
        }
        
        if let date = DateFormatters.vkDateFormatter.date(from: self) {
            return Calendar.current.dateComponents([.day, .month], from: date)
        }
        
        return nil
    }
}
