//
//  SearchBarAndCameraButton.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/5/24.
//

import SwiftUI
import SwiftData

struct SearchBarAndCameraButton: View {
    @EnvironmentObject var manager : BooksManager
    @Environment(\.modelContext) private var context
    @Query private var lists : [BookList]
    @Binding var search : String
    @Binding var showCamera : Bool
    @Binding var showSheet : Bool
    var body: some View {
        GeometryReader{ proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            HStack{
                Spacer()
                TextField("Search Shelves", text: $search)
                    .padding(8)
                    .background(.placeholder)
                    .clipShape(Capsule())
                    .onSubmit {
                        if(!manager.searchShelves(query: search, lists: lists)){
                            search = "Not Found"
                        }else{
                            search = ""
                        }
                    }
                    .frame(width: width / 2, height: 20)
                Spacer()
                Button{
                    showCamera.toggle()
                }label:{
                    Image(systemName: "camera")
                        .font(.system(size: width / 10))
                }
                Spacer()
                AddListButton(showSheet: $showSheet)
                Spacer()
            }
        }
    }
}

#Preview {
    SearchBarAndCameraButton(search: .constant(""), showCamera: .constant(false), showSheet: .constant(false))
        .frame(height: 40)
        .environmentObject(BooksManager())
}
