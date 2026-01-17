//
//  GameList.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 06.01.2026.
//

import SwiftUI
import SwiftData

struct GameList: View {
    // MARK: Data In
    @Environment(\.words) var words
    @Environment(\.modelContext) var modelContext

    // MARK: Data Shared with Me
    @Binding var selection: CodeWord?
    @Binding var showSettings: Bool
    @Query private var games: [CodeWord]
    @Query private var settings: [Settings]
    
    // MARK: Data Owned by Me
    private var currentSettings: Settings {
        if let existing = settings.first {
            return existing
        } else {
            return Settings()
        }
    }
    
    // MARK: - Init
    
    init(guessesContain search: String, filterOption: FilterOption, selection: Binding<CodeWord?>, showSettings: Binding<Bool>) {
        self._selection = selection
        self._showSettings = showSettings
        
        // Search text
        let lowercaseSearch = search.lowercased()
        
        // Filters
        let showAll = filterOption == .all
        let showActive = filterOption == .active
        let showCompleted = filterOption == .completed
        
        // Filter predicate
        let predicate = #Predicate<CodeWord> { game in
            (showAll || (showActive && !game.isGameOver) || (showCompleted && game.isGameOver)) &&
            (search.isEmpty || game._attempts.contains(where: { $0.word.contains(lowercaseSearch) }))
        }
        
        // Sort
        let sort: [SortDescriptor<CodeWord>] = [
            .init(\.lastAttemptDate, order: .reverse),
            .init(\.initDate, order: .reverse)
        ]
        
        self._games = Query(
            filter: predicate,
            sort: sort
        )
    }

    // MARK: - Body
    
    var body: some View {
        List(selection: $selection) {
            gamesSection
        }
        .toolbar {
            ToolbarItem(placement: .automatic) { /// - Adds new game button
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
            ToolbarItem(placement: .automatic) { /// - Adds settings button
                settingsButton
            }
        }
        .onChange(of: words.count) { /// - Adds some games if there are none.
            addSampleGames()
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
                for offset in offsets {
                    modelContext.delete(games[offset])
                }
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
    /// - Pre-Loading
    
    /// Retrieves games and adds some if there are none.
    func addSampleGames() {
        let fetchDescriptor = FetchDescriptor<CodeWord>()
        let results = try? modelContext.fetch(fetchDescriptor)
        
        if (words.count != 0), (results?.count == 0) {
            addGame(CodeWord(length: currentSettings.wordLength))
            addGameWithAttempts()
            addGameFinished()
        }
    }
    
    func addGameFinished(){
        let game = CodeWord()
        setMasterCode(in: game)
        makeAttempt(with: game.masterCode.letters, in: game)
        addGame(game)
    }
    
    func addGameWithAttempts(){
        let game = CodeWord()
        setMasterCode(in: game)
        fillAttempts(in: game)
        addGame(game)
    }
    
    func setMasterCode(in game: CodeWord) {
        let masterWord = words.random(length: currentSettings.wordLength) ?? "ERROR"
        game.masterCode.letters = masterWord.map { String($0) }
    }
    
    func fillAttempts(in game: CodeWord) {
        for _ in 0..<(Int.random(in: 2...4)) {
            let word = words.random(length: currentSettings.wordLength) ?? "ERROR"
            
            makeAttempt(with: word.map { String($0) }, in: game)
        }
    }
    
    func makeAttempt(with letters: [Letter], in game: CodeWord) {
        game.guess.letters = letters
        game.makeAttempt()
    }
    
    // MARK: - Game Array Operations
    
    func addGame(_ game: CodeWord) {
        modelContext.insert(game)
    }
    
    func addAndShowGame(length: Int? = nil) {
        let game = if let length {
            CodeWord(length: length)
        } else {
            CodeWord(length: currentSettings.wordLength)
        }
        addGame(game)
        selection = game
    }
    
    enum FilterOption: CaseIterable {
        case all
        case active
        case completed
        
        var title: String {
            switch self {
            case .all: "All"
            case .active: "Active"
            case .completed: "Completed"
            }
        }
    }
}

//#Preview {
//    GameList()
//}
