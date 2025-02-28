//
//  BookInfoView.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/3/24.
//

import SwiftUI

struct BookInfoView: View {
    @Binding var showDescription : Bool
    let book: Book
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25.0)
                .fill(.placeholder)
            VStack{
                Spacer()
                Text(book.title)
                if(book.subtitle != ""){
                    Text(book.subtitle!)
                        .minimumScaleFactor(0.9)
                }
                if(!(book.authors?.isEmpty ?? true)){
                    Text("By: \(book.authors![0])")
                }
                if(book.publishedDate != ""){
                    Text("Published: \(book.publishedDate!)")
                }
                if(book.description != ""){
                    Button{
                        showDescription.toggle()
                    }label:{
                        Text("Description")
                            .underline()
                    }
                }
                Spacer()
            }
            .font(.custom("Optima", size: 24))
            .fontWeight(.bold)
            .lineLimit(1)
        }
    }
}

#Preview {
    BookInfoView(showDescription: .constant(false), book: Book.mainDefault)
        .frame(height: 200)
}
