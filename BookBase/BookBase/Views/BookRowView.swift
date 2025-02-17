//
//  BookRowView.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/21/24.
//

import SwiftUI

struct BookRowView: View {
    var book : UserBook
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25.0)
                .fill(.placeholder)
            HStack{
                let image : String = book.book.imageLinks?.thumbnail ?? "ImageNA"
                BookCover(image: image, isUrl: image != "ImageNA")
                    .frame(width: 80, height: 100)
                Spacer()
                VStack{
                    Text(book.book.title)
                    Text(book.book.subtitle ?? "")
                    let authorName = book.book.authors?.first ?? "NA"
                    Text("Written by: \(authorName)")
                }
                .padding()
            }
        }
        .padding()
    }
}
