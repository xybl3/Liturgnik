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
                                    
                                }
                            }
                            else if let psalm = lecturesViewModel.lectures[index] as? Psalm{
                                NavigationLink("Psalm"){
                                    PsalmView(psalm: psalm)
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
                InternetConnectionErrorView()
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
    
    @State private var fontSize: CGFloat = 20
    
    var body: some View {
        ScrollView {
            Text(lecture.content)
                .font(.system(size: fontSize).monospaced())
                .padding()
            
        }
        .navigationTitle(lecture.sigle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ZoomInOutButtons(fontSize: $fontSize)
            }
        }
    }
}

struct PsalmView: View {
    let psalm: Psalm
    
    @State private var fontSize: CGFloat = 20
    
    var body: some View {
        ScrollView{
            ForEach(psalm.verses, id: \.self) { verse in
                Text(verse)
                    .font(.system(size: fontSize).monospaced())
                Text(psalm.chorus)
                    .font(.system(size: fontSize).monospaced().weight(.black))
                    .padding(.vertical)
            }
        }
        .navigationTitle("Psalm")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ZoomInOutButtons(fontSize: $fontSize)
            }
        }
    }
}



struct ZoomInOutButtons: View {
    @Binding var fontSize: CGFloat
    var body: some View {
        HStack {
            Button {
                if fontSize > 5 {
                    fontSize-=1
                }
            } label: {
                Text("a")
            }
            Divider()
            Button {
                if fontSize < 50 {
                    fontSize+=1
                }
            } label: {
                Text("A")
            }
        }
    }
}

#Preview {
    LiturgyView(lecturesViewModel: LecturesViewModel())
}
