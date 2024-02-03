//
//  MszalWidget.swift
//  MszalWidget
//
//  Created by Olivier Marszałkowski on 11/01/2024.
//

import WidgetKit
import SwiftUI



struct WidgetEntry: TimelineEntry {
    let date: Date
    let mszal: Mszal?
    let occasion: String?
}

struct MszalWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(DateUtils.formatLocalizedDate(date: entry.date))")
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            if let occasion = entry.occasion {
                    Text(occasion)
                        .font(.footnote)
                        .lineLimit(1)
                        .truncationMode(.tail)
                Divider()
            }
            
            if let mszal = entry.mszal {
                Text("Formularz: \(mszal.formularz)")
                    .font(.footnote)
                    .lineLimit(1)
                Divider()
                Text("Prefacje: \(mszal.prefacja.joined(separator: ","))")
                    .font(.footnote)
                    .lineLimit(1)
                Divider()
                Text("Modlitwa: \(String(mszal.modlitwa.split(separator: " ")[0]))")
                    .font(.footnote)
                    .lineLimit(1)
            }
            else {
                Text("Brak danych. Poczekaj na ponowne odświeżenie.")
            }
            Spacer()
        }
    }
}

struct MszalWidget: Widget {
    let kind: String = "MszalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MszalWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MszalWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Mszał")
        .description("Ten widget pokazuje dzisiejsze ustawienie mszału.")
        .supportedFamilies([.systemSmall])
    }
}

//#Preview(as: .systemSmall) {
//    MszalWidget()
//} timeline: {
//    WidgetEntry(date: .now, mszal: .init)
//    WidgetEntry(date: .now, emoji: "🤩")
//}
