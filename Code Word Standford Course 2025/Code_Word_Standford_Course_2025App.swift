//
//  Code_Word_Standford_Course_2025App.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 12.12.2025.
//

import SwiftUI
import CoreData
import SwiftData

@main
struct Code_Word_Standford_Course_2025App: App {

    var body: some Scene {
        WindowGroup {
            GameCenter()
                .modelContainer(for: [CodeWord.self, Settings.self])
        }
    }
}
