//
//  ProgressWidget.swift
//  ProgressWidget
//
//  Created by Brendan Kenney on 4/13/24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct ProgressWidget: Widget {
    let kind: String = "ProgressWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ProgressWidgetEntryView(entry: entry)
                    .containerBackground(LinearGradient(colors: [Color(red: 168 / 255, green: 224 / 255, blue: 255 / 255), Color(red: 57 / 255, green: 43 / 255, blue: 88 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing), for: .widget)
            } else {
                ProgressWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Reading Widget")
        .description("Keep track of your reading progress.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
