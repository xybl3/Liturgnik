//
//  LiturgnikApp.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 09/01/2024.
//

import SwiftUI

@main
struct LiturgnikApp: App {
    
    init(){
    
        Task {
           await ApiConnector.shared.fetchData()
            NotificationManager.shared.requestNotificationPermissions()
            
//
//            let ch = Calendar.current.component(.hour, from: .now)
//            let cm = Calendar.current.component(.minute, from: .now)
//            
//            NotificationManager.shared.scheduleNotification(hour:ch, minutes: cm+1)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
