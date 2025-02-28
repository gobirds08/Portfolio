//
//  ListOfLists.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/12/24.
//

import SwiftUI
import SwiftData

struct ListOfLists: View {
    @EnvironmentObject var manager : BooksManager
    @Environment(\.modelContext) private var context
    @Query private var lists : [BookList]
    @Binding var showSheet : Bool
    @Binding var showEditListSheet : Bool
    @Binding var editing : Bool
    @Binding var listToEdit : String
    var body: some View {
        ScrollView(.vertical){
            VStack(spacing: 10){
                ForEach(lists){ list in
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.placeholder)
                        VStack{
                            HStack{
                                Text(list.name)
                                    .bold()
                                    .offset(x: 15, y: 5)
                                Spacer()
                                if(list.name != "Read" && list.name != "Currently Reading" && list.name != "Want to Read"){
                                    ListMenu(showEditListSheet: $showEditListSheet, editing: $editing, listToEdit: $listToEdit, list: list)
                                        .offset(x: -15, y: 5)
                                }
                            }
                                GeometryReader{ proxy in
                                    ScrollView(.horizontal){
                                    HStack(spacing: 0){
                                        ForEach(list.books.reversed()){ book in
                                            let width = proxy.size.width
                                            let height = proxy.size.height
                                            var image : String = book.book.imageLinks?.thumbnail ?? "ImageNA"
                                            Button{
                                                manager.changeBook(book: book)
                                                showSheet.toggle()
                                            }label:{
                                                BookCover(image: image, isUrl: image != "ImageNA")
                                                    .frame(width: 80, height: height - 15)
                                            }
                            
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 150)
                }
            }
        }
        .padding()
    }
}
