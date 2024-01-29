//
//  Provider.swift
//  ColorWidgetExtension
//
//  Created by Olivier Marszałkowski on 07/01/2024.
//

import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), family: context.family, today: .init(date: Date(), vestmentColor: .purple, occasion: nil), tomorrow: nil, liturgyYear: "B")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(
            date: Date(),
            family: context.family,
            today: .init(
                date: Calendar.current.date(from: .init(year: 2023, month: 12, day: 10))!,
                vestmentColor: .purple, occasion: "II Tydzień Adwentu"),
            tomorrow: context.family == .systemSmall ? nil : .init(
                date: Calendar.current.date(from: .init(year: 2023, month: 12, day: 11))!,
                vestmentColor: .purple,
                occasion: "Dzień Powszedni albo wspomnienie św. Damazego I, papieża"), liturgyYear: "B")
        completion(entry)
    }
    
    
    
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> ()) {
        Task {
            do {
                let currentDate = Date()
                
                NiedzielaScraper.shared.setDate(to: currentDate)
                try await NiedzielaScraper.shared.performScrape()
                
                let vestment = try NiedzielaScraper.shared.getVestmentColor().get()
                let occasion = try NiedzielaScraper.shared.getDayOccasion().get()
                
                let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                NiedzielaScraper.shared.setDate(to: tomorrowDate)
                try await NiedzielaScraper.shared.performScrape()
                
                let vestment2 = try NiedzielaScraper.shared.getVestmentColor().get()
                let occasion2 = try NiedzielaScraper.shared.getDayOccasion().get()
                
                let lirugryYear = NiedzielaScraper.shared.fetchYear()
                
                
                // The code here will execute after the asynchronous operations are done.
                
                let entry = WidgetEntry(date: currentDate, family: context.family, today: .init(date: currentDate, vestmentColor: vestment, occasion: occasion), tomorrow: .init(date: tomorrowDate, vestmentColor: vestment2, occasion: occasion2), liturgyYear: lirugryYear)
                
                
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                
                print("ColorWidget timeline created")
                completion(timeline)
                // Call the completion handler with the timeline
                
            } catch {
                // Handle errors
                print("Error: \(error)")
            }
        }
    }




    
}
