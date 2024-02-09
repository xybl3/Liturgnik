//
//  HomeView.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 30/01/2024.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject var lecturesViewModel: LecturesViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var settingsSheetDisplayed = false
    
    var body: some View {
        Group {
            switch lecturesViewModel.loadingStatus {
            case .success:
                List {
                    Section("Ogólne") {
                        HStack {
                            Text("Kolor szat liturgicznych:")
                            Spacer()
                            Text(lecturesViewModel.vestmentColor.value)
                                .foregroundStyle(ColorUtils.getTextColorBasedOnVestureColor(for: lecturesViewModel.vestmentColor, in: colorScheme))
                        }
                    }
                    Section("Wspomnienie"){
                        Text(lecturesViewModel.occasion ?? "Nie można pobrać")
                    }
                    Section("Udział we mszy"){
                        switch lecturesViewModel.shouldAttend {
                        case true:
                            Text("Udział we mszy świętej nakazany!")
                                .bold()
                                .foregroundStyle(.red)
                                
                        case false:
                            Text("Udział we mszy świętej nie jest nakazany")
                            
                        case _:
                            Text("Brak informacji")
                        }
                    }
                }
            case .loading:
                ProgressView()
            case .error:
                InternetConnectionErrorView()
            }
        }
        .transition(.opacity)
        .navigationTitle("Ogólne")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ToolbarDatePicker(lecturesViewModel: lecturesViewModel)
            }
        }
        .sheet(isPresented: $settingsSheetDisplayed, onDismiss: {
            settingsSheetDisplayed = false
        }, content: { SettingsView() })
        
    }
}

struct ToolbarDatePicker: View {
    @StateObject var lecturesViewModel: LecturesViewModel
    
    var body: some View {
        DatePicker("", selection: $lecturesViewModel.selectedDate, displayedComponents: .date)
            .environment(\.locale, Locale.init(identifier: "pl"))
            .foregroundStyle(Color.accentColor)
            .onChange(of: lecturesViewModel.selectedDate) { test in
                withAnimation(.spring) {
                    lecturesViewModel.changeDate(to: lecturesViewModel.selectedDate)
                }
            }
    }
}


#Preview {
    HomeView(lecturesViewModel: LecturesViewModel())
}
