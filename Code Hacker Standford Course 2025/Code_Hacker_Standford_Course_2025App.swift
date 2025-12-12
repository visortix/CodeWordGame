//
//  Code_Hacker_Standford_Course_2025App.swift
//  Code Hacker Standford Course 2025
//
//  Created by visortix on 12.12.2025.
//

import SwiftUI
import CoreData

@main
struct Code_Hacker_Standford_Course_2025App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
