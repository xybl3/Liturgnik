//
//  ContentView.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 09/01/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var lecturesViewModel = LecturesViewModel()
    
    @State private var selection = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                HomeView(lecturesViewModel: lecturesViewModel)
                    .tag(0)
                    .tabItem({
                        Image(systemName: "house")
                        Text("Ogólne")
                    })
                LecturesView(lecturesViewModel: lecturesViewModel)
                    .tag(1)
                    .tabItem({
                        Image(systemName: "book")
                        Text("Liturgia")
                    })
            }
            .navigationTitle(selection == 0 ? "Ogólne" : "Liturgia")
//            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    ContentView()
}
