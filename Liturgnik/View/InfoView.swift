//
//  InfoView.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 24/01/2024.
//

import SwiftUI

struct InfoView: View {
    @EnvironmentObject private var vm: LecturesViewModel
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    
    @State private var settingsSheetDisplayed = false
    
    var body: some View {
        NavigationStack {
            if vm.isLoading {
                ProgressView()
            }
            else if vm.isError {
                Text("error")
            }
            else {
                List {
//                    Text("✝︎")
//                        .font(.system(size: 50))
//                        .foregroundColor(ColorUtils.getTextColorBasedOnVestureColor(for: vm.vestmentColor, in: colorScheme))
                    Section {
                        HStack {
                            Text("Kolor: ")
                            Spacer()
                            Text(vm.vestmentColor.toString())
                                .foregroundColor(ColorUtils.getTextColorBasedOnVestureColor(for: vm.vestmentColor, in: colorScheme))
                                .minimumScaleFactor(0.5)
                        }
                        HStack {
                            VStack{
                                Text(DateUtils.formatLocalizedDate(date: vm.date).split(separator: " ")[0])
                                    .font(.title2)
                                Text(DateUtils.formatLocalizedDate(date: vm.date).split(separator: " ")[1])
                                    .font(.footnote)
                                
                            }
                            Spacer()
                            Text(vm.occasion)
                                .foregroundColor(ColorUtils.getTextColorBasedOnVestureColor(for: vm.vestmentColor, in: colorScheme))
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    switch vm.shouldAttend {
                    case true:
                        Section("Ważne"){
                            Text("Udział we mszy św nakazany!")
                                .foregroundStyle(.red)
                        }
                    case false:
                        Section("Udział we mszy świętej"){
                            Text("Udział nie jest nakazany")
                        }
                        
                    case _:
                        Text("Brak informacji o nakazaniu")
                    
                        
                    }
                    
                    Section("Mszał"){
                        if let mszal = vm.mszal {
                            HStack {
                                Text("Strona: ")
                                Spacer()
                                Text(mszal.formularz)
                                    .minimumScaleFactor(0.3)
                            }
                            HStack {
                                Text("Prefacja:")
                                Spacer()
                                Text(mszal.prefacja.joined(separator: " lub "))
                                    .minimumScaleFactor(0.3)
                            }
                            HStack {
                                Text("Modlitwa:")
                                Spacer()
                                Text(mszal.modlitwa)
                                    .minimumScaleFactor(0.3)
                            }
                            
                        } else {
                            Text("Brak danych mszału na dzisiaj")
                        }
                    }
                    
                }
                .navigationTitle("Ogólne")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing){
                        Button {
                            settingsSheetDisplayed.toggle()
                        } label: {
                            Image(systemName: "gear")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $settingsSheetDisplayed, onDismiss: {
            settingsSheetDisplayed = false
        }, content: {SettingsView()})
    }
}

#Preview {
    InfoView()
        .environmentObject(LecturesViewModel())
}
