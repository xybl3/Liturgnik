//
//  ContentView.swift
//  LiturgnikWatch Watch App
//
//  Created by Olivier Marszałkowski on 03/02/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var lecturesViewModel = LecturesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                //                NavigationLink(destination: {
                //                    ToolbarDatePicker(lecturesViewModel: lecturesViewModel)
                //                }, label: {
                //                    Text(DateUtils.formatLocalizedDate(date: lecturesViewModel.selectedDate))
                //                })
                NavigationLink(destination: {
                    Ogolne(lecturesViewModel: lecturesViewModel)
                }, label: {
                    Text("Ogólne")
                })
                NavigationLink(destination: {
                    Liturgia(lecturesViewModel: lecturesViewModel)
                }, label: {
                    Text("Liturgia")
                })
            }
            .navigationTitle("Liturgnik")
        }
        
    }
}

#Preview {
    ContentView()
}



struct Ogolne: View {
    @StateObject var lecturesViewModel: LecturesViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Group {
            switch lecturesViewModel.loadingStatus {
            case .success:
                List {
                    Section("Kolor szat") {
                        HStack {
                            Text(lecturesViewModel.vestmentColor.value)
                                .foregroundStyle(ColorUtils.getTextColorBasedOnVestureColor(for: lecturesViewModel.vestmentColor, in: colorScheme))
                        }
                    }
                    Section("Wspomnienie"){
                        NavigationLink(destination: {
                            ScrollView {
                                Text(lecturesViewModel.occasion ?? "Nie można pobrać")
                            }
                        }, label: {
                            Text(lecturesViewModel.occasion ?? "Nie można pobrać")
                                .lineLimit(1)
                        })
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
        .navigationTitle("Ogólne")
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

struct Liturgia: View {
    @StateObject var lecturesViewModel: LecturesViewModel
    
    var body: some View {
        Group {
            switch lecturesViewModel.loadingStatus {
            case .success:
                List {
                    Section("Czytania") {
                        ForEach(lecturesViewModel.lectures.indices, id: \.self) { index in
                            if let lecture = lecturesViewModel.lectures[index] as? Lecture {
                                NavigationLink(lecture.sigle){
                                    LectureView(lecture: lecture)
                                        .navigationTitle(lecture.sigle)
                                        .navigationBarTitleDisplayMode(.inline)
                                }
                            }
                            else if let psalm = lecturesViewModel.lectures[index] as? Psalm{
                                NavigationLink("Psalm"){
                                    PsalmView(psalm: psalm)
                                        .navigationTitle("Psalm")
                                        .navigationBarTitleDisplayMode(.inline)
                                }
                            }
                        }
                    }
                    if let mszal = lecturesViewModel.mszal {
                        Section("Mszał") {
                            HStack {
                                Text("Formularz")
                                Spacer()
                                Text(mszal.formularz)
                            }
                            HStack {
                                Text("Prefacja")
                                Spacer()
                                Text(mszal.prefacja.joined(separator: " lub "))
                            }
                        }
                    }
                }
            case .loading:
                ProgressView()
            case .error:
                Text("Wystąpił błąd :(")
            }
        }
        .navigationTitle("Liturgia")    }
}


struct LectureView: View {
    let lecture: Lecture
    
    
    var body: some View {
        ScrollView {
            Text(lecture.content)
                .monospaced()
                .padding()
        }
    }
}

struct PsalmView: View {
    let psalm: Psalm
    
    var body: some View {
        ScrollView{
            ForEach(psalm.verses, id: \.self) { verse in
                Text(verse)
                    .monospaced()
                Text(psalm.chorus)
                    .fontWeight(.black)
                    .padding(.vertical)
                    .monospaced()
            }
            .padding()
        }
    }
}
