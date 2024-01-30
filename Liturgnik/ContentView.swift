//
//  ContentView.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 09/01/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var lecturesViewModel = LecturesViewModel()
    
    var body: some View {
        Text(lecturesViewModel.occasion ?? "Brak okazji")
    }
}


#Preview {
    ContentView()
}
