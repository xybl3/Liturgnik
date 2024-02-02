//
//  LiturgyView.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 30/01/2024.
//

import SwiftUI

struct LiturgyView: View {
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
        .navigationTitle("Liturgia")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ToolbarDatePicker(lecturesViewModel: lecturesViewModel)
            }
        }
        //        .navigationBarTitleDisplayMode(.inline)
    }
    
}


struct LectureView: View {
    let lecture: Lecture
    
    var body: some View {
        ScrollView {
            Text(lecture.content)
                .fontDesign(.monospaced)
        }
        .padding()
    }
}

struct PsalmView: View {
    let psalm: Psalm
    
    var body: some View {
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
    }
}

#Preview {
    LiturgyView(lecturesViewModel: LecturesViewModel())
}
