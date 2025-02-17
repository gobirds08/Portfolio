//
//  SearchView.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/6/24.
//

import SwiftUI
import SwiftData


struct SearchView: View {
    @EnvironmentObject var manager : BooksManager
    @Environment(\.modelContext) private var context
    @Query private var lists : [BookList]
    @State private var search = ""
    var body: some View {
        GeometryReader{ proxy in
            let width = proxy.size.width
            ZStack{
                LinearGradient.main
                    .ignoresSafeArea(.all)
                VStack{
                    HStack{
                        Spacer()
                        TextField("Search All", text: $search)
                            .padding(8)
                            .background(.placeholder)
                            .clipShape(Capsule())
                            .onSubmit {
                                manager.testSearch(query: search, lists: lists)
                                search = ""
                            }
                            .frame(width: width / 2, height: 20)
                        Spacer()
                    }
                    .frame(height: 75)
                    GenresView()
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(BooksManager())
}
