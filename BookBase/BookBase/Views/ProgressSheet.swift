//
//  ProgressSheet.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/14/24.
//

import SwiftUI
import SwiftData

struct ProgressSheet: View {
    @EnvironmentObject var manager : BooksManager
    @Binding var progress : String
    @Binding var showSheet : Bool
    @Binding var book : UserBook
    @Environment(\.modelContext) private var context
    @Query private var lists : [BookList]
    var body: some View {
        ZStack{
            LinearGradient.main
                .ignoresSafeArea()
            VStack{
                SheetCapsule()
                    .offset(y: -40)
            HStack{
                Spacer()
                TextField("%", text: $progress)
                    .padding(8)
                    .background(.placeholder)
                    .border(.placeholder)
                    .foregroundStyle(Color.white)
                    .clipShape(Rectangle())
                    .frame(width: 80)
                Button{
                    editProgress()
                    showSheet.toggle()
                }label:{
                    Text("Submit")
                        .padding(8)
                        .background(.placeholder)
                        .clipShape(Capsule())
                }
                .disabled(!manager.isValidProgress(numString: progress))
                Spacer()
            }
            .foregroundStyle(Color("Text"))
        }
        }
    }
    
    func editProgress(){
        book.userInfo.percentage = Int(progress)!
        for list in lists{
            if(list.books.contains(where: {$0.book.isbn == book.book.isbn})){
                list.books.removeAll(where: {$0.book.isbn == book.book.isbn})
                list.books.append(book)
                try? context.save()
            }
        }
    }
}
