//
//  LiturgnikApp.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 09/01/2024.
//

import SwiftUI

@main
struct LiturgnikApp: App {
    
    init(){
        Task {
           await ApiConnector.shared.fetchData()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
