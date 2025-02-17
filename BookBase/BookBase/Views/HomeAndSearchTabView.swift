//
//  HomeAndSearchTabView.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/6/24.
//

import SwiftUI

struct HomeAndSearchTabView: View {
    @EnvironmentObject var manager : BooksManager
    var body: some View {
        TabView{
            Home()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            ListTabView()
                .tabItem{
                    Label("Lists", systemImage: "list.bullet")
                }
        }
        .sheet(isPresented: $manager.showBook, content: {
            DetailBookView(book: $manager.bookToShow)
        })
    }
}

#Preview {
    HomeAndSearchTabView()
        .environmentObject(BooksManager())
}
