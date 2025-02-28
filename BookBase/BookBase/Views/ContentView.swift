//
//  ContentView.swift
//  BookBase
//
//  Created by Brendan Kenney on 3/28/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var manager : BooksManager
    @State private var searchAll = ""
    @Environment(\.modelContext) private var context
    @Query private var lists : [BookList]
    var body: some View {
        HomeAndSearchTabView()
            .ignoresSafeArea()
            .foregroundStyle(Color("DarkPurple"))
            .onAppear{
                addDefaults()
            }
    }
    
    func addDefaults(){
        if(lists.isEmpty){
            context.insert(BookList.read)
            context.insert(BookList.wantToRead)
            context.insert(BookList.currently)
        }
    }
}

extension LinearGradient{
    static let main = LinearGradient(colors: [Color("LightBlue"), Color("DarkPurple")], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    static let alternate = LinearGradient(colors: [Color("GreenGray"), Color("LightBlue")], startPoint: .topLeading, endPoint: .bottomTrailing)
}
