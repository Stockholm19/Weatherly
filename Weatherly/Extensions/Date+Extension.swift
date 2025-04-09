//
//  Date+Extension.swift
//  Weatherly
//
//  Created by Роман Пшеничников on 08.04.2025.
//

import Foundation

extension Date {
    func localDate(for timeZone: TimeZone) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
    func localTime(for timeZone: TimeZone) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
    
    func localWeekDay(for timeZone: TimeZone) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
}
