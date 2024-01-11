//
//  ContentView.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 09/01/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = LecturesViewModel()
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            
            VStack {
                if vm.isLoading == false {
                    List {
                        Section("Informacje"){
                            Text(vm.occasion)
                            
                            HStack{
                                Text("Kolor szat:")
                                Spacer()
                                Text(vm.vestmentColor.rawValue)
                                    .foregroundColor({
                                        let textColor: Color
                                        switch vm.vestmentColor {
                                        case .green: textColor = .green
                                        case .pink: textColor = .pink
                                        case .purple: textColor = .purple
                                        case .red: textColor = .red
                                        case .white: textColor = .white
                                        case .other: textColor = .black
                                        case _: textColor = .black
                                        }
                                        
                                        if textColor == .white && self.colorScheme == .light {
                                            return .black
                                        }
                                        
                                        return textColor
                                    }())
                                    .bold()
                            }
                            
                        }
                        
                        Section("Liturgia"){
                            ForEach(vm.lectures.indices, id: \.self) { index in
                                if let lecture = vm.lectures[index] as? Lecture {
                                    NavigationLink(lecture.sigle){
                                        ScrollView {
                                            Text(lecture.content)
                                                .fontDesign(.monospaced)
                                                .padding()
                                        }
                                        .navigationTitle(lecture.sigle)
                                        .navigationBarTitleDisplayMode(.inline)
                                    }
                                }
                                else if let psalm = vm.lectures[index] as? Psalm{
                                    NavigationLink("Psalm"){
                                        ScrollView{
                                            ForEach(psalm.verses, id: \.self) { verse in
                                                Text(verse)
                                                    .fontDesign(.monospaced)
                                                Text(psalm.chorus)
                                                    .fontWeight(.black)
                                                    .padding(.vertical)
                                                    .fontDesign(.monospaced)
                                                
                                            }
                                        }
                                        .padding()
                                        .navigationTitle("Psalm")
                                        .navigationBarTitleDisplayMode(.inline)
                                        //                                .toolbarRole(.editor) //that is really buggy idk why
                                    }
                                }
                            }
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
                }
                else {
                    ProgressView()
                }
            }
            
            .navigationTitle(DateUtils.formatLocalizedDate(date: vm.date))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    Button {
                        vm.setDate(to: Calendar.current.date(byAdding: .day, value: 1, to: vm.date)!)
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                }
                ToolbarItem(placement: .topBarLeading){
                    Button {
                        vm.setDate(to: Calendar.current.date(byAdding: .day, value: -1, to: vm.date)!)
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
