//
//  LecturesView.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 24/01/2024.
//

import SwiftUI

struct LecturesView: View {
    @EnvironmentObject private var vm: LecturesViewModel
    @State private var tabbarVisibility: Visibility = .visible
    var body: some View {
        List {
            Section("Czytania na dzień"){
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
                            .navigationTitle("Psalm")
                            .navigationBarTitleDisplayMode(.inline)
                            
                            .padding()
                            
                            //                                                                .toolbarRole(.editor) //that is really buggy idk why
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LecturesView()
        .environmentObject(LecturesViewModel())
}
