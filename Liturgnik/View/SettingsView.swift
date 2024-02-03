//
//  SettingsView.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 01/02/2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Section("Powiadomienia") {
                NavigationLink(destination: { NotificationSettingsView() }, label: {
                    Text("Powiadomienia")
                })
            }
        }
        .navigationTitle("Ustawienia")
    }
}


struct NotificationSettingsView: View {
    @StateObject var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        List {
            Toggle("Powiadomienia", isOn: $settingsViewModel.isNotificationsEnabled)
            DatePicker("Godzina", selection: $settingsViewModel.notificationTime, displayedComponents: .hourAndMinute)
                .disabled(!settingsViewModel.isNotificationsEnabled)
        }
        .onChange(of: settingsViewModel.notificationTime ){ newValue in
            
            settingsViewModel.handleDateChange()
            
        }
        .onChange(of: settingsViewModel.isNotificationsEnabled) { newValue in
            settingsViewModel.handleStatusChange()
        }
        
        .navigationTitle("Powiadomienia")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview{
    SettingsView()
}


