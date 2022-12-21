//
//  ArcheryWidget.swift
//  ArcheryWidget
//
//  Created by Elvis on 16/12/2022.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct ArcheryWidgetEntryView : View {
//    var entry: Provider.Entry

    var body: some View {
        Image("IconForWidget")
            .resizable()
    }
}

struct ArcheryWidget: Widget {
    let kind: String = "Archery Marker"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ArcheryWidgetEntryView()
        }
        .configurationDisplayName("Big Icon")
        .description("Show the Archery Marker with bigger icon.")
        .supportedFamilies([.systemSmall])
    }
}

struct ArcheryWidget_Previews: PreviewProvider {
    static var previews: some View {
        ArcheryWidgetEntryView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
