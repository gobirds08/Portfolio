//
//  DetailBookView.swift
//  BookBase
//
//  Created by Brendan Kenney on 3/31/24.
//

import SwiftUI

struct DetailBookView: View {
    @Binding var book : UserBook
    @State private var showDescription = false
    @State private var showListsList = false
    @State private var showProgressSheet = false
    @State private var progress : String = ""
    @State private var notesSheet = false
    @State private var datesSheet = false
    var body: some View {
        GeometryReader{ proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let image : String = book.book.imageLinks?.thumbnail ?? "ImageNA"
            ZStack{
                LinearGradient.alternate
                    .ignoresSafeArea()
                VStack(spacing: 25){
                    BookCover(image: image, isUrl: image != "ImageNA")
                        .frame(width: ((height / 2.5) * (2 / 3)), height: height / 2.5)
                    BookInfoView(showDescription: $showDescription, book: book.book)
                        .frame(height: height / 5)
                    BookFunctionalityView(book: $book, showListsList: $showListsList, showProgressSheet: $showProgressSheet, showNotes: $notesSheet, showDates: $datesSheet)
                        .frame(height: height / 5)
                }
                .sheet(isPresented: $showDescription, content: {
                    ZStack{
                        LinearGradient.alternate
                            .ignoresSafeArea()
                        VStack{
                            SheetCapsule()
                                .offset(y: 5)
                            ScrollView(.vertical){
                                Text(book.book.description!)
                                    .padding()
                            }
                        }
                    }
                })
                .sheet(isPresented: $showListsList, content: {
                    ListOfBookLists(book: book)
                })
                .sheet(isPresented: $showProgressSheet, content: {
                    ProgressSheet(progress: $progress, showSheet: $showProgressSheet, book: $book)
                        .presentationDetents([.fraction(0.2)])
                })
                .sheet(isPresented: $notesSheet, content: {
                    NotesView(book: $book)
                })
                .sheet(isPresented: $datesSheet, content: {
                    EditDates(book: $book)
                })
                .padding()
            }
        }
    }
}
