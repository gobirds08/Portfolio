//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/14/24.
//

import SwiftUI

@main
struct PokedexApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var manager : PokedexManager = PokedexManager()
    var body: some Scene {
        WindowGroup {
            MainRows()
                .environmentObject(manager)
                .onChange(of: scenePhase){ oldValue, newValue in
                    switch newValue{
                    case .background:
                        manager.save()
                    default:
                        break
                    }
                }
        }
    }
}
