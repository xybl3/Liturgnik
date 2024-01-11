//
//  Provider.swift
//  MszalWidgetExtension
//
//  Created by Olivier Marszałkowski on 11/01/2024.
//

import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), mszal: .init(id: 1, dateFrom: "2024-01-09", dateTo: "2024-01-09", formularz: "123", prefacja: ["12", "32"], modlitwa: "II Modlitwa Eucharystyczna", wyjatki: nil), occasion: "Testowa")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(date: Date(), mszal: .init(id: 1, dateFrom: "2024-01-09", dateTo: "2024-01-09", formularz: "123", prefacja: ["12", "32"], modlitwa: "II Modlitwa Eucharystyczna", wyjatki: nil), occasion: nil)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> ()) {
        Task {
            var entries: [WidgetEntry] = []
            
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            
            
            
            await ApiConnector.shared.fetchData()
            
            let msz = ApiConnector.shared.getMszal()?.first(where: { m in
                print(m.id)
                if let dateFrom = DateUtils.dateFromString(from: m.dateFrom){
                    if let dateTo = DateUtils.dateFromString(from: m.dateTo) {
                        
                        //                        print("Date \(self.date.description) is \(isWithinRange(targetDate: self.date, startDate: dateFrom, endDate: dateTo))")
                        
                        return DateUtils.isWithinRange(targetDate: currentDate, startDate: dateFrom, endDate: dateTo)
                    }
                }
                return false
            })
            
            NiedzielaScraper.shared.setDate(to: currentDate)
            try? await NiedzielaScraper.shared.performScrape()
            
            let occasion = try? NiedzielaScraper.shared.getDayOccasion().get()
            
            
            let entry = WidgetEntry(date: Date(), mszal: msz, occasion: occasion)
            entries.append(entry)
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}
