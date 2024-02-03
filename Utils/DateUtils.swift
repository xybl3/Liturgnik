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
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "pl")
        
        return dateFormatter.string(from: date)
    }
    
    static func formatDayMonth(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
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
    
    static func parseHourMinuteToDate(hourMinuteString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let hourMinuteComponents = dateFormatter.date(from: hourMinuteString) {
            let today = Date()
            
            let calendar = Calendar.current
            
            let components = calendar.dateComponents([.hour, .minute], from: hourMinuteComponents)
            
            var todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
            
            todayComponents.hour = components.hour
            todayComponents.minute = components.minute
            
            return calendar.date(from: todayComponents)
        }
        
        return nil
    }

}
