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
    
    static func parseHourMinuteToDate(hourMinuteString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // Set the format for hour and minute
        
        if let hourMinuteComponents = dateFormatter.date(from: hourMinuteString) {
            // Get today's date
            let today = Date()
            
            // Get the calendar
            let calendar = Calendar.current
            
            // Extract hour and minute components from the provided time
            let components = calendar.dateComponents([.hour, .minute], from: hourMinuteComponents)
            
            // Get today's date components
            var todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
            
            // Set the hour and minute components from the provided time
            todayComponents.hour = components.hour
            todayComponents.minute = components.minute
            
            // Construct a new date using today's date and the provided hour and minute
            return calendar.date(from: todayComponents)
        }
        
        return nil
    }

}
