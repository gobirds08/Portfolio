//
//  WidgetView.swift
//  ProgressWidgetExtension
//
//  Created by Brendan Kenney on 4/13/24.
//

import WidgetKit
import SwiftUI

struct ProgressWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch(widgetFamily){
        case .systemSmall:
            SmallWidget(entry: entry)
        case .systemMedium:
            MediumWidget(entry: entry)
        default:
            SmallWidget(entry: entry)
        }
    }
}
