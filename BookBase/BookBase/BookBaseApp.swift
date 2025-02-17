//
//  BookBaseApp.swift
//  BookBase
//
//  Created by Brendan Kenney on 3/28/24.
//
//
//  References:
//
//  SwiftData used throughout referenced from "CodeWithChris" on YouTube
//  Link: https://www.youtube.com/watch?v=krRkm8w22A8
//
//  Widget used throughout referenced from "Sean Allen" on YouTube
//  Link: https://youtube.com/watch?v=jucm6e9M6LA&t=1368s
//
//  Camera used throughout referenced from "Neuralception" on YouTube
//  Link: https://youtube.com/watch?v=cLnw5z8ZGqM
//
//  TextRecognition used throughout referenced from "scriptpapi" on YouTube
//  Link: https://youtube.com/watch?v=ttLq_Ef1rpo&t=167s
//

import SwiftUI
import SwiftData
import WidgetKit

@main
struct BookBaseApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var manager = BooksManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
                .onChange(of: scenePhase){ oldValue, newValue in
                    switch(newValue){
                    case .background:
                        WidgetCenter.shared.reloadTimelines(ofKind: "ProgressWidget")
                    default:
                        break
                    }
                }
            
        }
        .modelContainer(for: BookList.self)
    }
}
