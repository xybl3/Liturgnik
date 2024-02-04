//
//  Provider.swift
//  ColorWidgetWatchExtension
//
//  Created by Olivier Marszałkowski on 04/02/2024.
//

import WidgetKit

struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), vestmentColor: .green, occation: "Niedziela zwykła")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = Entry(date: Date(), vestmentColor: .green, occation: nil)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let now = Date.now
            NiedzielaScraper.shared.setDate(to: now)
            do {
                try await NiedzielaScraper.shared.performScrape()
                NiedzielaScraper.shared.getVestmentColor()
                    .publisher
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            print("There was an error \(error.localizedDescription)")
                        }
                    } receiveValue: { result in
                        let timeline = Timeline(entries: [
                            SimpleEntry(date: now, vestmentColor: result, occation: nil)
                        ], policy: .atEnd)
                        completion(timeline)
                    }
                    .cancel()

                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
