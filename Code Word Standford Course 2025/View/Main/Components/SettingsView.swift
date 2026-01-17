//
//  SettingsView.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 07.01.2026.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    // MARK: Data In
    @Environment(\.modelContext) var modelContext

    // MARK: Data Shared with Me
    @Query private var settings: [Settings]
    @Environment(\.dismiss) var dismiss
        
    // MARK: Data Owned by Me
    private var currentSettings: Settings {
        if let existing = settings.first {
            return existing
        } else {
            return Settings()
        }
    }
    
    var body: some View {
        @Bindable var bindableSettings = currentSettings
        
        NavigationStack {
            Form {
                Section("Word settings") {
                    /// Number of letters
                    Picker("Word length", selection: $bindableSettings.wordLength) {
                        ForEach(3...5, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                }
                Section("UI") {
                    /// Shape to use in guess
                    Picker("Shape in guess", selection: $bindableSettings.guessShape) {
                        ForEach(Settings.ShapeType.allCases, id: \.self) { shape in
                            Text(shape.rawValue.capitalized)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) { 
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        .onDisappear {
            do {
                try modelContext.save()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}



#Preview(traits: .swiftData) {
    SettingsView()
}
