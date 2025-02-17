//
//  ListOfBookLists.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/10/24.
//

import SwiftUI
import SwiftData

struct ListOfBookLists: View {
    @EnvironmentObject var manager : BooksManager
    @Environment(\.modelContext) private var context
    @Query private var lists : [BookList]
    var book : UserBook
    var body: some View {
        ZStack{
            LinearGradient.main
                .ignoresSafeArea()
            VStack{
                SheetCapsule()
                    .offset(y: 5)
                HStack{
                    Text("Lists")
                        .font(.system(size: 40))       .bold()
                        .offset(x: 30)
                    Spacer()
                }
                List{
                    ForEach(lists){ list in
                        let inList = list.books.contains(where: {$0.book.isbn == book.book.isbn})
                        Button{
                            if(inList){
                                deleteFromList(list: list)
                            }else{
                                addToList(list: list)
                            }
                        }label:{
                            HStack{
                                Text(list.name)
                                Spacer()
                                Image(systemName: inList ? "checkmark.square.fill" : "square")
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    
                }
                .scrollContentBackground(.hidden)
            }
        }
        .foregroundStyle(Color("DarkPurple"))

    }
    
    func addToList(list: BookList){
        list.books.append(book)
        try? context.save()
    }
    
    func deleteFromList(list: BookList){
        list.books.removeAll(where: {$0.book.isbn == book.book.isbn})
        try? context.save()
    }
}

#Preview {
    ListOfBookLists(book: UserBook.mainDefault)
        .environmentObject(BooksManager())
}
