//
//  SettingsView.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 07.01.2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.settings) var settings
    @Environment(\.dismiss) var dismiss
        
    var body: some View {
        @Bindable var bindableSettings = settings
        
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
            settings.save()
        }
    }
}



#Preview {
    SettingsView()
}
