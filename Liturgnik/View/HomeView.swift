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
                        Text(lecturesViewModel.occasion ?? "")
                    }
                    Section("Udział we mszy"){
                        switch lecturesViewModel.shouldAttend {
                        case true:
                            Text("Udział we mszy świętej nakazany!")
                                .foregroundStyle(.red)
                                .bold()
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
                Text("Wystąpił błąd :(")
            }
        }
        .transition(.opacity)
//        .refreshable {
//            
//        }
        
        .navigationTitle("Ogólne")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ToolbarDatePicker(lecturesViewModel: lecturesViewModel)
            }
//            ToolbarItem(placement: .topBarLeading) {
//                Button {
//                    settingsSheetDisplayed.toggle()
//                } label: {
//                    Image(systemName: "gear")
//                }
//            }
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
//            .blendMode(.overlay)
            .foregroundStyle(Color.accentColor)
        //                            .id(lecturesViewModel.selectedDate) // TODO: make that animation
            .onChange(of: lecturesViewModel.selectedDate, {
                withAnimation(.spring(.snappy)) {
                    lecturesViewModel.changeDate(to: lecturesViewModel.selectedDate)
                }
            })
    }
}
//        Text(DateUtils.formatLocalizedDate(date: lecturesViewModel.selectedDate))
////            .foregroundStyle(Color.accentColor)
//            .overlay {
//                DatePicker("", selection: $lecturesViewModel.selectedDate, displayedComponents: .date)
//                    .blendMode(.overlay)
//                    .foregroundStyle(Color.accentColor)
//                //                            .id(lecturesViewModel.selectedDate) // TODO: make that animation
//                    .onChange(of: lecturesViewModel.selectedDate, {
//                        withAnimation(.spring(.snappy)) {
//                            lecturesViewModel.changeDate(to: lecturesViewModel.selectedDate)
//                        }
//                    })
//            }
//    }
//}

#Preview {
    HomeView(lecturesViewModel: LecturesViewModel())
}
