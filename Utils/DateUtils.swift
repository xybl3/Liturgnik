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

}
