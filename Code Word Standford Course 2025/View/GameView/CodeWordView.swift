//
//  CodeWordView.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 12.12.2025.
//

import SwiftUI
import SwiftData
import GameKit

struct CodeWordView: View {
    // MARK: Data Shared with Me
    let codeWord: CodeWord
    @Query private var settings: [Settings]

    // MARK: Data In
    @Environment(\.words) var words
    @Environment(\.scenePhase) var scenePhase
    
    // MARK: Data Owned by Me
    @State private var selection = 0
    @State private var restarting = false
    private var currentSettings: Settings {
        if let existing = settings.first {
            return existing
        } else {
            return Settings()
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            masterCode
            scroll
            controls
        }
        .trackElapsedTime(in: codeWord)
        .onChange(of: words.count, initial: true) {
           initGame()
        }
        .toolbar {
            ToolbarItem { timer }
        }
        .padding()
    }
    
    // MARK: - UI
    
    var timer: some View {
        ElapsedTime(
            startTime: codeWord.startTime,
            endTime: codeWord.endTime,
            elapsedTime: codeWord.elapsedTime
        )
        .monospacedDigit()
        .fixedSize()
    }
    
    var masterCode: some View {
        Group {
            if !restarting {
                CodeView(code: codeWord.masterCode)
                    .blur(radius: MasterCode.blurRadius(isOver: codeWord.isGameOver))
                    .transition(.opacityBlur())
            } else {
                CodeView(code: Code(kind: .master, count: codeWord.count))
            }
        }
        .animation(nil, value: restarting)
    }
    
    var scroll: some View {
        ScrollView {
            if !codeWord.isGameOver {
                CodeView(code: codeWord.guess, selection: $selection)
                    .padding(CodeView.GuessLine.padding)
                    .transition(.guess)
            }
            ForEach(codeWord.attempts.indices.reversed(), id: \.self) { index in
                CodeView(code: codeWord.attempts[index])
                    .transition(.attempt(codeWord.isGameOver))
            }
        }
    }
    
    @ViewBuilder
    var controls: some View {
        ControlPanel(
            isGameOver: codeWord.isGameOver,
            restarting: $restarting,
            onRestart: restart,
            onDelete: delete,
            onGuess: guess,
            fillGameCode: fillGameCode
        )
        if !codeWord.isGameOver {
            Keyboard(
                choices: codeWord.choices,
                slotIndex: selection,
                slotLetterStatuses: codeWord.slotLetterStatuses
            ) { letter in
                codeWord.guess.letters[selection] = letter
                selection = (selection + 1) % codeWord.count
            }
            .transition(.keyboard)
        }
    }
    
    // MARK: - Logic Functions
    
    func fillGameCode() {
        let length = codeWord.customLenght ?? currentSettings.wordLength
        codeWord.masterCode.letters = (words.random(length: length) ?? "ERROR").map { String($0) }
    }
    
    func restart() {
        codeWord.restart()
        fillGameCode()
        selection = 0
    }
    
    func delete() {
        codeWord.guess.letters[selection] = ""
        selection = if (selection == 0) && !codeWord.isGuessEmpty {
            codeWord.count - 1
        } else {
            max(0, selection - 1)
        }
    }
    
    func guess() {
        codeWord.makeAttempt()
        selection = 0
    }
    
    func prepareNewGame(_ newGame: CodeWord) {
        if !newGame.isGameOver, newGame.masterCode.isEmpty {
            fillGameCode()
        }
        selection = 0
    }
    
    func initGame() {
        if codeWord.attempts.isEmpty {
            if words.count == 0 {
                codeWord.masterCode.letters = ["W", "A", "I", "T"]
            } else {
                fillGameCode()
            }
        }
    }
    
    // MARK: - Types
    
    struct MasterCode {
        static func blurRadius(isOver: Bool) -> CGFloat {
            isOver ? 0 : 10
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var codeWord = CodeWord()
    CodeWordView(codeWord: codeWord)
}
