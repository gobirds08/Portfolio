//
//  SearchResults.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/21/24.
//

import SwiftUI

struct SearchResults: View {
    @EnvironmentObject var manager : BooksManager
    @Binding var books : [UserBook]
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient.main
                    .ignoresSafeArea()
            VStack(spacing: 0){
                SheetCapsule()
                    .offset(y: 5)
                Text("Search Results")
                    .bold()
                    .font(.system(size: 40))
                ScrollView(.vertical){
                    ForEach($books){ book in
                        NavigationLink{
                            DetailBookView(book: book)
                        }label:{
                            BookRowView(book: book.wrappedValue)
                                .frame(height: 170)
                        }
                    }
                }
                }
            }
        }
    }
}

#Preview {
    SearchResults(books: .constant([UserBook.mainDefault, UserBook.mainDefault]))
        .environmentObject(BooksManager())
}
