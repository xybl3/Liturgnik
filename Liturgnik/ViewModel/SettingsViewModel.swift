//
//  SettingsViewModel.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 01/02/2024.
//

import Foundation

class SettingsViewModel: ObservableObject {
    
    @Published var isNotificationsEnabled = false
    @Published var notificationTime: Date = .now
    
    init() {
        self.isNotificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        
        let hmString = UserDefaults.standard.string(forKey: "notificationDate")
        
        
        if let hmString = hmString {
            let parsedDate = DateUtils.parseHourMinuteToDate(hourMinuteString: hmString)
            
            if let parsedDate = parsedDate {
                self.notificationTime = parsedDate
            }
        }
    }
    
    func handleDateChange(){
        if isNotificationsEnabled {
            let hour = Calendar.current.component(.hour, from: notificationTime)
            let minutes =  Calendar.current.component(.minute, from: notificationTime)
            
            NotificationManager.shared.removeAllNotifications()
            
            NotificationManager.shared.scheduleNotification(hour: hour, minutes: minutes)
            
            UserDefaults.standard.setValue("\(hour):\(minutes)", forKey: "notificationDate")
            
            
        }
        
    }
    
    func handleStatusChange(){
        if isNotificationsEnabled == false {
            NotificationManager.shared.removeAllNotifications()
        }
        
        UserDefaults.standard.setValue(isNotificationsEnabled, forKey: "notificationsEnabled")
    }
    
}
