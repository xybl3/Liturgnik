//
//  InfoView.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 24/01/2024.
//

import SwiftUI

struct InfoView: View {
    @EnvironmentObject private var vm: LecturesViewModel
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    var body: some View {
        if vm.isLoading {
            ProgressView()
        }
        else if vm.isError {
            Text("error")
        }
        else {
            List {
                Section {
                    
                    HStack {
                        VStack{
                            VStack {
                                Text("24")
                                    .font(.title3)
                                Text("stycznia")
                                    .font(.footnote)
                            }
                            Text("✝︎")
                                .font(.system(size: 50))
                                .foregroundColor(ColorUtils.getTextColorBasedOnVestureColor(for: vm.vestmentColor, in: colorScheme))
                        }
                        Spacer()
                        Text(vm.occasion)
                            .foregroundColor(ColorUtils.getTextColorBasedOnVestureColor(for: vm.vestmentColor, in: colorScheme))
                    }
                }
                
                Section("Mszał"){
                    if let mszal = vm.mszal {
                        HStack {
                            Text("Strona: ")
                            Spacer()
                            Text(mszal.formularz)
                                .minimumScaleFactor(0.3)
                        }
                        HStack {
                            Text("Prefacja:")
                            Spacer()
                            Text(mszal.prefacja.joined(separator: " lub "))
                                .minimumScaleFactor(0.3)
                        }
                        HStack {
                            Text("Modlitwa:")
                            Spacer()
                            Text(mszal.modlitwa)
                                .minimumScaleFactor(0.3)
                        }
                        
                    } else {
                        Text("Brak danych mszału na dzisiaj")
                    }
                }
            }
        }
    }
}

#Preview {
    InfoView()
        .environmentObject(LecturesViewModel())
}
