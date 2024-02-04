//
//  ColorWidgetWatch.swift
//  ColorWidgetWatch
//
//  Created by Olivier Marszałkowski on 04/02/2024.
//

import WidgetKit
import SwiftUI



struct SimpleEntry: TimelineEntry {
    let date: Date
    let vestmentColor: VestmentColor
    let occation: String?
}

struct ColorWidgetWatchEntryView : View {
    @Environment(\.colorScheme) private var colorScheme
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.vestmentColor.value)
                .foregroundColor(ColorUtils.getTextColorBasedOnVestureColor(for: entry.vestmentColor, in: colorScheme))
        }
    }
}

@main
struct ColorWidgetWatch: Widget {
    let kind: String = "ColorWidgetWatch"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(watchOS 10.0, *) {
                ColorWidgetWatchEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ColorWidgetWatchEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Kolor szat")
        .description("Kolor szat liturgicznych dzisiaj.")
    }
}
//
//#Preview(as: .accessoryRectangular) {
//    ColorWidgetWatch()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}
