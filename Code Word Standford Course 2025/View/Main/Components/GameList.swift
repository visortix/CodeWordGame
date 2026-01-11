//
//  GameList.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 06.01.2026.
//

import SwiftUI

struct GameList: View {
    // MARK: Data In
    @Environment(\.words) var words
    @Environment(\.settings) var settings
    
    // MARK: Data Owned by Me
    @State private var games: [CodeWord] = []

    // MARK: Data Shared with Me
    @Binding var selection: CodeWord?
    @Binding var showSettings: Bool
    
    // MARK: - Body
    
    var body: some View {
        List(selection: $selection) {
            gamesSection
        }
        .onChange(of: games) {
            withAnimation(.bouncy(duration: 10)) {
                sortGames()
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                newGameButton
                    .contextMenu {
                        Button("3 letters") {
                            addAndShowGame(length: 3)
                        }
                        Button("4 letters") {
                            addAndShowGame(length: 4)
                        }
                        Button("5 letters") {
                            addAndShowGame(length: 5)
                        }
                        Button("6 letters") {
                            addAndShowGame(length: 6)
                        }
                    }
            }
            ToolbarItem(placement: .automatic) {
                settingsButton
            }
        }
        .onChange(of: words.count) {
            if words.count != 0 {
                addGame(CodeWord(length: settings.wordLength))
                addGameWithAttempts()
                addGameFinished()
            }
        }
    }
    
    // MARK: - UI
    
    var gamesSection: some View {
        Section("Games") {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameOverview(game: game)
                }
            }
            .onDelete { offsets in
                games.remove(atOffsets: offsets)
            }
        }
    }
    
    var newGameButton: some View {
        Button("Start new game") {
            addAndShowGame()
        }
    }
    
    var settingsButton: some View {
        Button {
            showSettings = true
        } label: {
            Image(systemName: "gear")
        }
    }
    
    // MARK: - Logic
    
    // MARK: - Pre-Loading
    
    func addGameFinished(){
        let game = CodeWord()
        setMasterCode(in: game)
        makeAttempt(with: game.masterCode.letters, in: game)
        games.insert(game, at: 0)
    }
    
    func addGameWithAttempts(){
        let game = CodeWord()
        setMasterCode(in: game)
        fillAttempts(in: game)
        games.insert(game, at: 0)
    }
    
    func setMasterCode(in game: CodeWord) {
        let masterWord = words.random(length: settings.wordLength) ?? "ERROR"
        game.masterCode.letters = masterWord.map { String($0) }
    }
    
    func fillAttempts(in game: CodeWord) {
        for _ in 0..<(Int.random(in: 2...4)) {
            let word = words.random(length: settings.wordLength) ?? "ERROR"
            
            makeAttempt(with: word.map { String($0) }, in: game)
        }
    }
    
    func makeAttempt(with letters: [Letter], in game: CodeWord) {
        game.guess.letters = letters
        game.makeAttempt()
    }
    
    // MARK: - Game Array Operations
    
    func addGame(_ game: CodeWord) {
        games.insert(game, at: 0)
    }
    
    func addAndShowGame(length: Int? = nil) {
        let game = if let length {
            CodeWord(length: length)
        } else {
            CodeWord(length: settings.wordLength)
        }
        addGame(game)
        selection = game
    }
    
    func sortGames(){
        games = games.sorted {
            $0.lastAttemptDate ?? $0.initDate > $1.lastAttemptDate ?? $1.initDate
        }
    }
}

//#Preview {
//    GameList()
//}
