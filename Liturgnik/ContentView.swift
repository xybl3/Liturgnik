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
    @State private var isLoading: Bool = true
    
    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                InfoView()
                    .environmentObject(vm)
                    .tabItem({
                        Image(systemName: "house")
                        Text("Ogólne")
                    })
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            BottomBar(vm: vm)
                        }
                    }
                    .tag(0)
                LecturesView()
                    .environmentObject(vm)
                    .tabItem({
                        Image(systemName: "book")
                        Text("Liturgia")
                    })
                    
                    .tag(1)
                    
            }
            
            SplashScreenView(isShown: $isLoading)
        }
        
    }
}

struct BottomBar: View {
    @StateObject var vm: LecturesViewModel
    var body: some View {
        VStack {
            HStack {
                Button {
                    vm.setDate(to: Calendar.current.date(byAdding: .day, value: -1, to: vm.date)!)
                } label: {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                HStack {
                    Text(DateUtils.formatLocalizedDate(date: vm.date))
                        .overlay{ //MARK: Place the DatePicker in the overlay extension
                            DatePicker(
                                "",
                                selection: $vm.date,
                                displayedComponents: [.date]
                            )
                            .blendMode(.destinationOver) //MARK: use this extension to keep the clickable functionality
                            .onChange(of: vm.date, {
                                vm.setDate(to: vm.date)
                                
                            })
                        }
                    
                }
                
                Spacer()
                Button {
                    vm.setDate(to: Calendar.current.date(byAdding: .day, value: 1, to: vm.date)!)
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
