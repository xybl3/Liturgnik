//
//  SettingsView.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 28/01/2024.
//

import SwiftUI

struct SettingsView: View {
   @StateObject private var vm = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            List {
                Section("Powiadomienia") {
                    NavigationLink("Powiadomienia"){
                        notificationsSettings
                    }
                }
            }
            .navigationTitle("Ustawienia")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}


extension SettingsView {
    
    var notificationsSettings: some View {
        List{
            Section("Status"){
                HStack {
                    Text("Status powiadomien")
                    Spacer()
                    Toggle(isOn: $vm.isNotificationsOn){}
                        .onChange(of: vm.isNotificationsOn, vm.handleStatusChange)
                }
            }
            Section("Godzina"){
                DatePicker(selection: $vm.notificationDateSet, displayedComponents: .hourAndMinute, label: { Text("Godzina")})
                    .disabled(!vm.isNotificationsOn)
                    .onChange(of: vm.notificationDateSet, vm.handleDateChange)
                
            }
        }
        .navigationTitle("Powiadomienia")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
    }
}

#Preview {
    SettingsView()
}
