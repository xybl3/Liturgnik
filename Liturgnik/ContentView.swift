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
                .toolbar {
                    ToolbarItem(placement: .bottomBar, content: {toolbar})
                }
                .tag(0)
            LecturesView()
                .environmentObject(vm)
                .tabItem({
                    Image(systemName: "book")
                    Text("Liturgia")
                })
                .toolbar {
                    ToolbarItem(placement: .bottomBar, content: {toolbar})
                }
                .tag(1)
        }
        
    }
}

extension ContentView {

    var toolbar: some View{
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
