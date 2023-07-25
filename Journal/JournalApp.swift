//
//  JournalApp.swift
//  Journal
//
//  Created by Mélissa Kintz on 25/07/2023.
//

import SwiftUI
import SwiftData

@main
struct JournalApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
