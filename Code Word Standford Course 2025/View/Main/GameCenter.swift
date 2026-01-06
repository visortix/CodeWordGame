//
//  GameCenter.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 31.12.2025.
//

import SwiftUI

struct GameCenter: View {
    // MARK: Data Owned by Me
    @State private var games: [CodeWord] = []
    
    var sortedGames: [CodeWord] {
        games.sorted { $0.lastAttemptDate ?? $0.startDate > $1.lastAttemptDate ?? $1.startDate }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Games") {
                    ForEach(sortedGames) { game in
                        NavigationLink(value: game) {
                            GameOverview(game: game)
                        }
                    }
                }
            }
            .navigationDestination(for: CodeWord.self) { game in
                CodeWordView(codeWord: game)
            }
            .navigationBarTitle("Game Center")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Start New Game") {
                        newGame()
                    }
                }
            }
        }
    }
    
    func newGame() {
        let newGame = CodeWord()
        games.append(newGame)
    }
}

#Preview {
    GameCenter()
}
