//
//  DateFormatters.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 14.09.2024.
//

import Foundation

struct DateFormatters {
    static var vkDateWithYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.M.yyyy"
        
        return formatter
    }
    
    static var vkDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.M"
        
        return formatter
    }
    
    static var dayAndMonthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        
        return formatter
    }
    
    static var dayAndMonthAndYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        
        return formatter
    }
}
