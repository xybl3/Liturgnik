//
//  Provider.swift
//  LecturesWidgetExtension
//
//  Created by Olivier Marszałkowski on 09/01/2024.
//

import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        return WidgetEntry(date: Date(), family: context.family, lectures: [
            Lecture(id: 1, sigle: "Iz 55, 1-11", heading: "", content: ""),
            Psalm(id: 2, chorus: "Będziecie czerpać ze zdrojów zbawienia", verses: [
            """
            Wy zaś z weselem czerpać będziecie wodę *
            ze zdrojów zbawienia.
            Chwalcie Pana, wzywajcie Jego imienia! †
            Ukażcie narodom Jego dzieła, *
            przypominajcie, że Jego imię jest chwalebne.
            """]),
            Lecture(id: 3, sigle: "1 J 5, 1-9", heading: "", content: ""),
            Lecture(id: 3, sigle: "Mk 1, 7-11", heading: "", content: "")
        ])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(date: Date(), family: context.family, lectures: [
            Lecture(id: 1, sigle: "Iz 55, 1-11", heading: "", content: ""),
            Psalm(id: 2, chorus: "Będziecie czerpać ze zdrojów zbawienia", verses: [
            """
            Wy zaś z weselem czerpać będziecie wodę *
            ze zdrojów zbawienia.
            Chwalcie Pana, wzywajcie Jego imienia! †
            Ukażcie narodom Jego dzieła, *
            przypominajcie, że Jego imię jest chwalebne.
            """]),
            Lecture(id: 3, sigle: "1 J 5, 1-9", heading: "", content: ""),
            Lecture(id: 3, sigle: "Mk 1, 7-11", heading: "", content: "")
        ])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> ()) {
        let currentDate = Date()
       
        Task {
            var entries: [WidgetEntry] = []
            
            
            NiedzielaScraper.shared.setDate(to: currentDate)
            try? await NiedzielaScraper.shared.performScrape()
            
            let lectures = try? NiedzielaScraper.shared.getLectures().get()
            
            
            
            let entry = WidgetEntry(date: currentDate, family: context.family, lectures: lectures ?? [])
            
            entries.append(entry)
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}
