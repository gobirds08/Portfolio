//
//  Provider.swift
//  ProgressWidgetExtension
//
//  Created by Brendan Kenney on 4/13/24.
//

import WidgetKit
import SwiftData
import SwiftUI

struct Provider: TimelineProvider {
    
    @MainActor func placeholder(in context: Context) -> ProgressEntry {
        ProgressEntry(date: Date(), lists: getBookLists())
    }

    @MainActor func getSnapshot(in context: Context, completion: @escaping (ProgressEntry) -> ()) {
        let entry = ProgressEntry(date: Date(), lists: getBookLists())
        completion(entry)
    }

    @MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<ProgressEntry>) -> ()) {
        let timeline = Timeline(entries: [ProgressEntry(date: .now, lists: getBookLists())], policy: .never)
        completion(timeline)
    }
    
    @MainActor
    private func getBookLists() -> [BookList]{
        guard let container = try? ModelContainer(for: BookList.self) else{
            return []
        }
        let descriptor = FetchDescriptor<BookList>()
        let lists = try? container.mainContext.fetch(descriptor)
        return lists ?? []
    }
}
