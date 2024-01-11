//
//  LecturesViewModel.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 09/01/2024.
//

import SwiftUI

class LecturesViewModel: ObservableObject {
    @Published var lectures: [Any] = []
    @Published var date: Date = .now
    @Published var occasion = ""
    @Published var vestmentColor: VestmentColor = .other
    @Published var mszal: Mszal? = nil
    
    @Published var isLoading: Bool = true
    
    
    
    
    
    func fetchDay(){
        Task {
            await MainActor.run {
                withAnimation {
                    isLoading = true
                }
            }
            NiedzielaScraper.shared.setDate(to:date)
            try? await NiedzielaScraper.shared.performScrape()
            let le = try? NiedzielaScraper.shared.getLectures().get()
            let oc = try? NiedzielaScraper.shared.getDayOccasion().get()
            let ve = try? NiedzielaScraper.shared.getVestmentColor().get()
            
            let msz = ApiConnector.shared.getMszal()?.first(where: { m in
                if let dateFrom = DateUtils.dateFromString(from: m.dateFrom){
                    if let dateTo = DateUtils.dateFromString(from: m.dateTo) {
                        
//                        print("Date \(self.date.description) is \(isWithinRange(targetDate: self.date, startDate: dateFrom, endDate: dateTo))")
                        
                        return DateUtils.isWithinRange(targetDate: self.date, startDate: dateFrom, endDate: dateTo)
                    }
                }
                return false
            })
            
            await MainActor.run {
                lectures = le ?? []
                occasion = oc ?? "Brak informacji"
                vestmentColor = ve ?? .other
                mszal = msz
                withAnimation{
                    isLoading = false
                }
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
