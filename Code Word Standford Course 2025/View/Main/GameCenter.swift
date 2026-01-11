//
//  GameCenter.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 31.12.2025.
//

import SwiftUI

struct GameCenter: View {
    // MARK: Data Owned by Me
    @State private var selection: CodeWord? = nil
    @State private var showSettings = false
    
    var body: some View {
        NavigationSplitView {
            GameList(selection: $selection, showSettings: $showSettings)
                .navigationTitle("Game Center")
        } detail: {
            if let selection {
                CodeWordView(codeWord: selection)
                    .navigationTitle(selection.isGameOver ? "Game Over" : "Code Word")
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Start new game to see")
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

#Preview {
    GameCenter()
}
