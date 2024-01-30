//
//  HomeView.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 30/01/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var lecturesViewModel: LecturesViewModel
    var body: some View {
        List {
            Text(lecturesViewModel.vestmentColor.value)
            
            NavigationLink("Test"){
                Text("S")
            }
        }
    }
}

#Preview {
    HomeView(lecturesViewModel: LecturesViewModel())
}
