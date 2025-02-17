//
//  NotesView.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/18/24.
//

import SwiftUI
import SwiftData

struct NotesView: View {
    @Environment(\.modelContext) private var context
    @Query private var lists : [BookList]
    @Binding var book : UserBook
    @State private var note = ""
    @State private var showAddNoteSheet = false
    @State private var editLists = false
    var body: some View {
        ZStack{
            LinearGradient.main
                .ignoresSafeArea()
            VStack{
                SheetCapsule()
                    .offset(y: 5)
                HStack(spacing: 170){
                    Text("Notes")
                        .bold()
                        .font(.system(size: 40))
                    Button{
                        showAddNoteSheet.toggle()
                    }label:{
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 25))
                    }
                }
                List{
                    ForEach(book.userInfo.notes, id: \.self){
                        note in
                        Text(note)
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 25.0).fill(.placeholder))
                    }
                    .onDelete(perform: deleteNote)
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
            .sheet(isPresented: $showAddNoteSheet, content: {
                AddNoteView(note: $note, showSheet: $showAddNoteSheet, editLists: $editLists)
                    .presentationDetents([.fraction(0.3)])
            })
            .onChange(of: editLists){
                if(editLists){
                    addNote()
                    editLists.toggle()
                }
            }
            .foregroundStyle(Color("DarkPurple"))
    }
    
    func addNote(){
        print("in here")
        book.userInfo.notes.append(note)
        note = ""
        for list in lists{
            if(list.books.contains(where: {$0.book.isbn == book.book.isbn})){
                list.books.removeAll(where: {$0.book.isbn == book.book.isbn})
                list.books.append(book)
                try? context.save()
            }
        }
    }
    
    func deleteNote(at offsets: IndexSet){
        book.userInfo.notes.remove(atOffsets: offsets)
        for list in lists{
            if(list.books.contains(where: {$0.book.isbn == book.book.isbn})){
                list.books.removeAll(where: {$0.book.isbn == book.book.isbn})
                list.books.append(book)
                try? context.save()
            }
        }
    }
}

#Preview {
    NotesView(book: .constant(UserBook.mainDefault))
}
