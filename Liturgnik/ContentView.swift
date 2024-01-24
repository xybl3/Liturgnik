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
    @State private var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {	
            InfoView()
                .environmentObject(vm)
                .tabItem({
                    Image(systemName: "info")
                    Text("Informacje")
                })
                .tag(0)
            LecturesView()
                .environmentObject(vm)
                .tabItem({
                    Image(systemName: "book")
                    Text("Liturgia")
                })
                .tag(1)
        }
    }
}

#Preview {
    ContentView()
}
