//
//  LecturesView.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 30/01/2024.
//

import SwiftUI

struct LecturesView: View {
    @StateObject var lecturesViewModel: LecturesViewModel
    var body: some View {
        List(lecturesViewModel.lectures.indices, id: \.self) { ind in
            if let lecture = lecturesViewModel.lectures[ind] as? Lecture {
                NavigationLink(lecture.sigle){
                    ScrollView {
                        Text(lecture.content)
                    }
                }
            }
            if let psalm = lecturesViewModel.lectures[ind] as? Psalm {
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
                }
            }
        }
    }
}

#Preview {
    LecturesView(lecturesViewModel: LecturesViewModel())
}
