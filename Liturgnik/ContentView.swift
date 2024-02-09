//
//  ContentView.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 09/01/2024.
//

import SwiftUI


fileprivate struct TabItem: Identifiable {
    let id = UUID()
    let icon: String
    let text: String
    let selection: ScreenSelection
}

fileprivate enum ScreenSelection: String {
    case home
    case lectures
    case settings
}


struct ContentView: View {
    @StateObject private var lecturesViewModel = LecturesViewModel()
    @State private var selection: ScreenSelection = .home
    @State private var isLoading = true
    
    
    @State private var isTabBarVisible = true
    
    
    fileprivate let tabItems: [TabItem] = [
        .init(icon: "house.fill", text: "Ogólne", selection: .home),
        .init(icon: "book.fill", text: "Liturgia", selection: .lectures),
        .init(icon: "gear", text: "Ustawienia", selection: .settings)
    ]
    
    var body: some View {
        NavigationView {
            ZStack (alignment: .bottom){
                Group {
                    switch selection {
                    case .home:
                        HomeView(lecturesViewModel: lecturesViewModel)
                            .tabItem({
                                Image(systemName: "house.fill")
                                Text("Ogólne")
                            })
                            .tag(ScreenSelection.home)
                    case .lectures:
                        LiturgyView(lecturesViewModel: lecturesViewModel)
                            .tabItem({
                                Image(systemName: "book.fill")
                                Text("Liturgia")
                            })
                            .tag(ScreenSelection.lectures)
                    case .settings:
                        SettingsView()
                            .tabItem({
                                Image(systemName: "gear")
                                Text("Ustawienia")
                            })
                            .tag(ScreenSelection.settings)
                    }
                }
                .padding(.bottom, 64)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                HStack {
                    ForEach(tabItems) { tabItem in
                        
                        Button{
                            withAnimation(.easeIn){
                                selection = tabItem.selection
                            }
                        } label: {
                            VStack(spacing: 0){
                                Image(systemName: tabItem.icon)
                                    .font(.system(size: 23, weight: .semibold))
                                    .frame(width: 32, height: 32)
                                Text(tabItem.text)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            
                            .frame(maxWidth: .infinity)
                            .foregroundColor(tabItem.selection == selection ? .accentColor : .secondary)
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 14)
                .frame(maxWidth: .infinity, maxHeight: 64, alignment: .top)
                .background(BlurEffect()
                    .ignoresSafeArea())
            }
        }
    }
}

#Preview {
    ContentView()
}
