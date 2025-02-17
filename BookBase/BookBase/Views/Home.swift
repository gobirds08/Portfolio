//
//  Home.swift
//  BookBase
//
//  Created by Brendan Kenney on 3/31/24.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var manager : BooksManager
    @State private var searchShelves = ""
    @State private var showCamera = false
    @State private var showAddListSheet = false
    @State private var showBookSheet = false
    @State private var editing = false
    @State private var listToEdit = ""
    var body: some View {
        ZStack{
            LinearGradient.main
                .ignoresSafeArea(.all)
                if(showCamera){
                    CameraView(showCamera: $showCamera)
                }else{
                    VStack(spacing: 0){
                        SearchBarAndCameraButton(search: $searchShelves, showCamera: $showCamera, showSheet: $showAddListSheet)
                            .frame(height: 75)
                        ListOfLists(showSheet: $showBookSheet, showEditListSheet: $showAddListSheet, editing: $editing, listToEdit: $listToEdit)
                    }
                    .sheet(isPresented: $showAddListSheet, content: {
                        CreateListView(showSheet: $showAddListSheet, editing: $editing, listToEdit: $listToEdit)
                            .presentationDetents([.fraction(0.2)])
                            .onDisappear{
                                editing = false
                            }
                    })
                    .sheet(isPresented: $showBookSheet, content: {
                        DetailBookView(book: $manager.bookToShow)
                    })
                    .sheet(isPresented: $manager.showSearchResults, content: {
                        SearchResults(books: $manager.booksToShow)
                    })
            }
        }
    }
}
