//
//  SettingsViewModel.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 28/01/2024.
//

import Foundation


class SettingsViewModel: ObservableObject {
    
    @Published var isNotificationsOn = false
    @Published var notificationDateSet: Date = .now
    
    init() {
        self.isNotificationsOn = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        
        let hmString = UserDefaults.standard.string(forKey: "notificationDate")

        
        if let hmString = hmString {
            let parsedDate = DateUtils.parseHourMinuteToDate(hourMinuteString: hmString)
            
            if let parsedDate = parsedDate {
                self.notificationDateSet = parsedDate
            }
        }
        
    }
    
    func handleDateChange(){
        if isNotificationsOn {
            let hour = Calendar.current.component(.hour, from: notificationDateSet)
            let minutes =  Calendar.current.component(.minute, from: notificationDateSet)
            
            NotificationManager.shared.removeAllNotifications()
            
            NotificationManager.shared.scheduleNotification(hour: hour, minutes: minutes)
            
            UserDefaults.standard.setValue("\(hour):\(minutes)", forKey: "notificationDate")
            
            
        }
        
    }
    
    func handleStatusChange(){
        if isNotificationsOn == false {
            NotificationManager.shared.removeAllNotifications()
        }
        
        UserDefaults.standard.setValue(isNotificationsOn, forKey: "notificationsEnabled")
    }
    
}
