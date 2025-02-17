//
//  ListTabView.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/27/24.
//

import SwiftUI
import SwiftData

struct ListTabView: View {
    @EnvironmentObject var manager : BooksManager
    @Environment(\.modelContext) private var context
    @Query private var lists : [BookList]
    @State private var listName = "Read"
    @State private var showSheet = false
    var body: some View {
        ZStack{
            LinearGradient.main
                .ignoresSafeArea()
            VStack{
                HStack{
                    Spacer()
                    Menu{
                        ForEach(lists){ list in
                            Button{
                                listName = list.name
                            }label:{
                                Text(list.name)
                            }
                        }
                    }label:{
                        Text("Change List")
                            .padding(8)
                            .background(.placeholder)
                            .clipShape(Capsule())
                            .offset(x: -10)
                    }
                }
                Text(listName)
                    .font(.title)
                    .bold()
                ListView(showSheet: $showSheet, listName: listName)
            }
        }
        .sheet(isPresented: $showSheet, content: {
            DetailBookView(book: $manager.bookToShow)
        })
    }
}
