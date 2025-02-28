//
//  BookFunctionalityView.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/3/24.
//

import SwiftUI
import SwiftData

struct BookFunctionalityView: View {
    @EnvironmentObject var manager : BooksManager
    @Environment(\.modelContext) private var context
    @Query private var lists : [BookList]
    @Binding var book : UserBook
    @Binding var showListsList : Bool
    @Binding var showProgressSheet : Bool
    @Binding var showNotes : Bool
    @Binding var showDates : Bool
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25.0)
                .fill(.placeholder)
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button{
                        toggleLikeBook()
                    }label:{
                        Image(systemName: book.userInfo.like ? "heart.fill" : "heart")
                            .font(.system(size: 20))
                    }
                    let currently = lists.first(where: {$0.name == "Currently Reading"})
                    if(currently!.books.contains(where: {$0.book.isbn == book.book.isbn})){
                        Spacer()
                        Button{
                            showProgressSheet.toggle()
                        }label:{
                            Text("Update Progress")
                                .padding(8)
                                .background(.placeholder)
                                .clipShape(Capsule())
                        }
                        Text("\(book.userInfo.percentage)%")
                    }
                    Spacer()
                    Button{
                        showListsList.toggle()
                    }label:{
                        Text("Edit Lists")
                            .padding(8)
                            .background(.placeholder)
                            .clipShape(Capsule())
                    }
                    Spacer()
                }
                Spacer()
                HStack{
                    Spacer()
                    Button{
                        showDates.toggle()
                    }label:{
                        Text("Edit Dates")
                            .padding(8)
                            .background(.placeholder)
                            .clipShape(Capsule())
                    }
                    Spacer()
                    Button{
                        showNotes.toggle()
                    }label:{
                        Text("Notes")
                            .padding(8)
                            .background(.placeholder)
                            .clipShape(Capsule())
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
    func toggleLikeBook(){
        book.userInfo.like.toggle()
        for list in lists{
            if(list.books.contains(where: {$0.book.isbn == book.book.isbn})){
                list.books.removeAll(where: {$0.book.isbn == book.book.isbn})
                list.books.append(book)
                try? context.save()
            }
        }
    }
}
