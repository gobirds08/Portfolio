//
//  BookCover.swift
//  BookBase
//
//  Created by Brendan Kenney on 3/31/24.
//

import SwiftUI

struct BookCover: View {
    let image : String
    let isUrl : Bool
    var body: some View {
            HStack{
                Spacer()
                if(isUrl){
                    AsyncImage(url: URL(string: image)){ image in
                        image.resizable()
                    }placeholder: {
                        ProgressView()
                    }
                }else{
                    Image(image)
                        .resizable()
                }
                Spacer()
            }
    }
}

#Preview {
    BookCover(image: Book.mainDefault.imageLinks?.thumbnail ?? "", isUrl: true)
}
