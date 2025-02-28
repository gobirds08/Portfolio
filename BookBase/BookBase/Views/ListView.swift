//
//  ListView.swift
//  BookBase
//
//  Created by Brendan Kenney on 3/31/24.
//

import SwiftUI
import SwiftData

struct ListView: View {
    @EnvironmentObject var manager : BooksManager
    @Environment(\.modelContext) private var context
    @Query private var lists : [BookList]
    @Binding var showSheet : Bool
    let listName : String
    var list : BookList {lists.first(where: {$0.name == listName}) ?? BookList(name: "", books: [])}
    var body: some View {
            List{
                ForEach(list.books){ book in
                    Button{
                        manager.changeBook(book: book)
                        showSheet.toggle()
                    }label:{
                        BookRowView(book: book)
                            .frame(height: 170)
                    }
                    .listRowBackground(Color.clear)
                }
                .onMove(perform: drag)
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
    }
    
    func drag(from start: IndexSet, to end: Int){
        list.books.move(fromOffsets: start, toOffset: end)
        try? context.save()
    }
}
