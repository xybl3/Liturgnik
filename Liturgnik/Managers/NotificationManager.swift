//
//  NotificationManager.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 28/01/2024.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    
    init() {
//        let center = UNUserNotificationCenter.current()
        
//        center.getPendingNotificationRequests { requests in
//            for request in requests {
//                print(request.trigger.debugDescription)
//                print(request.content.debugDescription)
//            }
//        }
    }
    
    func requestNotificationPermissions(){
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound, .criticalAlert]) { granted, error in
            
            if let error = error {
                print("🔔 [NotificationManager] there was error with notification authorization: \(error.localizedDescription)")
                
                return
            }
            
            if granted {
                print("🔔 [NotificationManager] notification permission granted!")
            }
            
        }
    }
    
    func scheduleNotification(hour: Int, minutes: Int) {
        let center = UNUserNotificationCenter.current()
        
        var date = DateComponents()
        date.hour = hour
        date.minute = minutes
        date.second = 0
        
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        buildLectureNotification { content in
            guard let content = content else {
                print("🔔 [NotificationManager] ailed to build notification content.")
                return
            }
            
            center.add(.init(identifier: "dev.marszalkowski.Liturgnik.powiadomienia", content: content, trigger: notificationTrigger)) { error in
                if let error = error {
                    print("🔔 [NotificationManager] Error scheduling notification: \(error)")
                } else {
                    print("🔔 [NotificationManager] Notification scheduled for \(hour):\(minutes)!")
                }
            }
        }
    }

    func removeAllNotifications() {
        let center = UNUserNotificationCenter.current()
        
        print("🔔 [NotificationManager] Removing every notification")
        
        center.removeAllPendingNotificationRequests()
    }
    
}


//enum NotificationContent {
//    case lection
//}
//

extension NotificationManager {
    fileprivate func buildLectureNotification(completion: @escaping (UNNotificationContent?) -> Void) {
        Task {
            do {
                NiedzielaScraper.shared.setDate(to: .now)
                try await NiedzielaScraper.shared.performScrape()
                let occ = try NiedzielaScraper.shared.getDayOccasion().get()
                
                let content = UNMutableNotificationContent()
                content.title = "Nowa liturgia"
                content.body = occ
                content.subtitle = "Sprawdz nowa liturgię na dzisiaj!"
                
                completion(content)
            } catch {
                print("Error building notification: \(error)")
                completion(nil)
            }
        }
    }
}