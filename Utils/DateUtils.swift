//
//  DateUtils.swift
//  Niedziela
//
//  Created by Olivier Marszałkowski on 08/01/2024.
//

import Foundation

class DateUtils {
    static func formatLocalizedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy" // Use 'd' for day, 'MMMM' for full month name, and 'yyyy' for year
        
        // Set the locale to get the month names in the desired language
        dateFormatter.locale = Locale(identifier: "pl")
        
        return dateFormatter.string(from: date)
    }

    static func dateFromString(from date: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date)
    }
    static func isWithinRange(targetDate: Date, startDate: Date, endDate: Date) -> Bool {
        let startOfDay = Calendar.current.startOfDay(for: startDate)
        let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate
        
        return targetDate >= startOfDay && targetDate <= endOfDay
    }
}
