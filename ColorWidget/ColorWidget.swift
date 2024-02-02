//
//  ColorWidget.swift
//  ColorWidget
//
//  Created by Olivier Marszałkowski on 07/01/2024.
//

import WidgetKit
import SwiftUI



struct WidgetEntry: TimelineEntry {
    let date: Date
    let family: WidgetFamily
    let today: DayEntry
    let tomorrow: DayEntry?
    let liturgyYear: String?
}


struct DayEntry {
    let date: Date
    let vestmentColor: VestmentColor
    let occasion: String?
    let shouldAttend: Bool?
}

struct ColorWidgetEntryView : View {
    @Environment(\.colorScheme) private var colorScheme
    var entry: Provider.Entry
    
    
    
    var body: some View {
        switch entry.family {
        case .systemMedium:
            HStack {
                renderTile(for: entry.today, year: entry.liturgyYear)
                if let en = entry.tomorrow {
                    Divider().frame(width: 1)
                    renderTile(for: en, year: entry.liturgyYear)
                        .opacity(0.6)
                }
            }
        case .accessoryRectangular:
            renderAccessory(for: entry.today, year: entry.liturgyYear)
        case _ :
            renderTile(for: entry.today, year: entry.liturgyYear)
        }
    }
    
    
    
    @ViewBuilder
    func renderTile(for entry: DayEntry, year: String?) -> some View{
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Text(DateUtils.formatDayMonth(date: entry.date))
                        .widgetAccentable()
                    Spacer()
                    if let shouldAttend = entry.shouldAttend {
                        if shouldAttend {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.caption)
                                .minimumScaleFactor(0.7)
                                .foregroundStyle(.red)
                        }
                    }
                }
                Text(entry.vestmentColor.value)
                    .lineLimit(1)
                    .font(.title2.bold())
                    .foregroundStyle(ColorUtils.getTextColorBasedOnVestureColor(for: entry.vestmentColor, in: colorScheme))
                    .widgetAccentable()
            }
            Spacer()
//            if let shouldAttend = entry.shouldAttend {
//                if shouldAttend {
//                    Text("Uczestnictwo nakazane")
//                        .font(.caption)
//                        .minimumScaleFactor(0.7)
//                        .foregroundStyle(.red)
//                }
//            }
            if let occasion = entry.occasion {
                VStack(alignment: .leading) {
                    Text(occasion)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    @ViewBuilder
    func renderAccessory(for entry: DayEntry, year: String?) -> some View {
        VStack(alignment: .leading) {
//            Text(DateUtils.formatLocalizedDate(date: .now))
            if let occasion = entry.occasion {
                Text(occasion)
                    .lineLimit(1)
            }
            if let year = year {
                Text(year)
                    .lineLimit(1)
            }
            HStack {
                Text("Kolor:")
                Text(entry.vestmentColor.value)
                    .bold()
            }
        }
    }
    
}
struct ColorWidget: Widget {
    let kind: String = "ColorWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ColorWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ColorWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Kolor szat")
        .description("Kolor szat liturgicznych na dany dzien")
        .supportedFamilies([.systemSmall, .accessoryRectangular, .systemMedium])
    }
}


//
//
//#Preview(as: .accessoryRectangular) {
//    ColorWidget()
//} timeline: {
//    WidgetEntry(
//        date: Date(),
//        family: .accessoryRectangular,
//        today: .init(
//            date: Calendar.current.date(from: .init(year: 2023, month: 12, day: 10))!,
//            vestmentColor: .purple, occasion: "II Tydzień Adwentu"), shouldAttend: false,
//        tomorrow: nil, liturgyYear: "Rok B, II")
//}
//
