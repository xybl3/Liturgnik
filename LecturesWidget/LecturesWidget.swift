//
//  LecturesWidget.swift
//  LecturesWidget
//
//  Created by Olivier Marszałkowski on 09/01/2024.
//

import WidgetKit
import SwiftUI


struct WidgetEntry: TimelineEntry {
    let date: Date
    let family: WidgetFamily
    let lectures: [Any]
}

struct LecturesWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            HStack {
                Text(DateUtils.formatLocalizedDate(date: entry.date))
                    .font(.title3)
                    .bold()
                Spacer()
            }
            VStack(alignment: .leading, spacing: 2) {
                ForEach(entry.lectures.indices, id: \.self) { index in
                    if let czytanie = entry.lectures[index] as? Lecture {
                        Text(czytanie.sigle)
                            .bold()
                            .lineLimit(1)
                            .font(.footnote)
                            
                    }
                    if let psalm = entry.lectures[index] as? Psalm {
                        Text(psalm.chorus)
                            .bold()
                            .lineLimit(1)
                            .font(.footnote)
                    }
                    Divider()
                }
            }
            .padding(.top, 1)
            Spacer()
        }
    }
}

struct LecturesWidget: Widget {
    let kind: String = "LecturesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                LecturesWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                LecturesWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Czytania")
        .description("Sigle czytan liturgicznych na dany dzień.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}





//#Preview(as: .systemMedium) {
//    LecturesWidget()
//} timeline: {
//    WidgetEntry(date: .now, family: .systemMedium, lectures: [
//        Lecture(id: 1, sigle: "1 Sm 1, 8-10", heading: "", content: "Testowy kontent czytania sjfkdjfklsdjfjsdlkfjdksfjkdsjfkdsajfjasdlkfklsjfkjsdklfjaldskjfkljsklfj"),
//        Psalm(id: 1, chorus: "Test test fksdkjfjkdsjfkldsklfjadksjfkjdkfjdkjfkjsdlkfjksldjf;asdjf;lasdjflskadjflkasdjflksdjfksdjfksdjlkj", verses: ["sjdjfkdsjfkjsdfkjsd"]),
//        Lecture(id: 2, sigle: "1 Kol 1, 8-10", heading: "", content: "Testowy kontent czytania sjfkdjfklsdjfjsdlkfjdksfjkdsjfkdsajfjasdlkfklsjfkjsdklfjaldskjfkljsklfj"),
//        
//        Lecture(id: 2, sigle: "Mt 3, 4-10", heading: "", content: "Testowy kontent czytania sjfkdjfklsdjfjsdlkfjdksfjkdsjfkdsajfjasdlkfklsjfkjsdklfjaldskjfkljsklfj"),
//    ])
//}
//#Preview(as: .systemLarge) {
//    LecturesWidget()
//} timeline: {
//    WidgetEntry(date: .now, family: .systemLarge, lectures: [
//        Lecture(id: 1, sigle: "1 Sm 1, 8-10", heading: "", content: "Testowy kontent czytania sjfkdjfklsdjfjsdlkfjdksfjkdsjfkdsajfjasdlkfklsjfkjsdklfjaldskjfkljsklfj"),
//        Psalm(id: 1, chorus: "Test test fksdkjfjkdsjfkldsklfjadksjfkjdkfjdkjfkjsdlkfjksldjf;asdjf;lasdjflskadjflkasdjflksdjfksdjfksdjlkj", verses: ["sjdjfkdsjfkjsdfkjsd"]),
//        Lecture(id: 2, sigle: "1 Kol 1, 8-10", heading: "", content: "Testowy kontent czytania sjfkdjfklsdjfjsdlkfjdksfjkdsjfkdsajfjasdlkfklsjfkjsdklfjaldskjfkljsklfj"),
//        
//        Lecture(id: 2, sigle: "Mt 3, 4-10", heading: "", content: "Testowy kontent czytania sjfkdjfklsdjfjsdlkfjdksfjkdsjfkdsajfjasdlkfklsjfkjsdklfjaldskjfkljsklfj"),
//    ])
//}
