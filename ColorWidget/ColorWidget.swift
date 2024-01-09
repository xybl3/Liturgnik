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
        VStack{
            VStack(alignment: .leading) {
                if let year = year {
                    Text("\(DateUtils.formatLocalizedDate(date: entry.date)) \(year)")
                        .minimumScaleFactor(0.2)
                } else {
                    Text("\(DateUtils.formatLocalizedDate(date: entry.date))")
                        .minimumScaleFactor(0.4)
                }
                if let occasion = entry.occasion {
                    Text(occasion)
                        .font(.footnote)
                        .minimumScaleFactor(0.1)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                
                Text("Kolor:")
                    .font(.title3)
                    .widgetAccentable()
                Text(entry.vestmentColor.rawValue)
                    .foregroundColor({
                        let textColor: Color
                        switch entry.vestmentColor {
                        case .green: textColor = .green
                        case .pink: textColor = .pink
                        case .purple: textColor = .purple
                        case .red: textColor = .red
                        case .white: textColor = .white
                        case .other: textColor = .black
                        case _: textColor = .black
                        }
                        
                        if textColor == .white && self.colorScheme == .light {
                            return .black
                        }
                        
                        return textColor
                    }())
                    .font(.title)
                    .minimumScaleFactor(0.3)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
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
                Text(entry.vestmentColor.rawValue)
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




#Preview(as: .accessoryRectangular) {
    ColorWidget()
} timeline: {
    WidgetEntry(
        date: Date(),
        family: .accessoryRectangular,
        today: .init(
            date: Calendar.current.date(from: .init(year: 2023, month: 12, day: 10))!,
            vestmentColor: .purple, occasion: "II Tydzień Adwentu"),
        tomorrow: nil, liturgyYear: "Rok B, II")
}

