//
//  LecturesViewModel.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 09/01/2024.
//

import Foundation

class LecturesViewModel: ObservableObject {
    @Published var lectures: [Any] = []
    @Published var date: Date = .now
    @Published var occasion = ""
    @Published var vestmentColor: VestmentColor = .other
    
    func fetchDay(){
        Task {
            NiedzielaScraper.shared.setDate(to:date)
            try? await NiedzielaScraper.shared.performScrape()
            let le = try? NiedzielaScraper.shared.getLectures().get()
            let oc = try? NiedzielaScraper.shared.getDayOccasion().get()
            let ve = try? NiedzielaScraper.shared.getVestmentColor().get()
            
            await MainActor.run {
                lectures = le ?? []
                occasion = oc ?? "Brak informacji"
                vestmentColor = ve ?? .other
            }
            
        }
    }
    
    
    func setDate(to d: Date){
        date = d
        fetchDay()
    }
    
    init() {
        fetchDay()
    }
}
