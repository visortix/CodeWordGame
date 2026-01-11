//
//  CodeWordView.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 12.12.2025.
//

import SwiftUI
import GameKit

struct CodeWordView: View {
    // MARK: Data Shared with Me
    let codeWord: CodeWord

    // MARK: Data In
    @Environment(\.words) var words
    @Environment(\.settings) var settings
    @Environment(\.scenePhase) var scenePhase
    
    // MARK: Data Owned by Me
    @State private var selection = 0
    @State private var restarting = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Group {
                if !restarting {
                    CodeView(code: codeWord.masterCode)
//                        .blur(radius: MasterCode.blurRadius(isOver: codeWord.isGameOver))
                        .transition(.opacityBlur())
                } else {
                    CodeView(code: Code(kind: .master, count: codeWord.count))
                }
            }
            .animation(nil, value: restarting)
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
        .onAppear {
            codeWord.startTimer()
        }
        .onDisappear {
            codeWord.pauseTimer()
        }
        .onChange(of: codeWord) { oldGame, newGame in
            oldGame.pauseTimer()
            newGame.startTimer()
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .active: codeWord.startTimer()
            case .background: codeWord.pauseTimer()
            default: break
            }
        }
        .onChange(of: codeWord) { _, newGame in
            if !newGame.isGameOver, newGame.masterCode.isEmpty {
                fillGameCode()
            }
            selection = 0
        }
        .onChange(of: words.count, initial: true) {
            if codeWord.attempts.isEmpty {
                if words.count == 0 {
                    codeWord.masterCode.letters = ["W", "A", "I", "T"]
                } else {
                    fillGameCode()
                }
            }
        }
        .trackElapsedTime(in: codeWord)
        .toolbar {
            ToolbarItem {
                ElapsedTime(startTime: codeWord.startTime, endTime: codeWord.endTime, elapsedTime: codeWord.elapsedTime)
                    .monospacedDigit()
                    .fixedSize()
            }
        }
        .padding()
    }
    
    // MARK: - Logic Functions
    
    func fillGameCode() {
        let length = codeWord.customLenght ?? settings.wordLength
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
    
    struct MasterCode {
        static func blurRadius(isOver: Bool) -> CGFloat {
            isOver ? 0 : 10
        }
    }
}

extension View {
    func trackElapsedTime(in game: CodeWord) -> some View {
        self.modifier(ElapsedTimeTracker(game: game))
    }
}

struct ElapsedTimeTracker: ViewModifier {
    @Environment(\.scenePhase) var scenePhase
    let game: CodeWord
    
    func body(content: Content) -> some View {
        content.onAppear {
            game.startTimer()
        }
        .onDisappear {
            game.pauseTimer()
        }
        .onChange(of: game) { oldGame, newGame in
            oldGame.pauseTimer()
            newGame.startTimer()
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .active: game.startTimer()
            case .background: game.pauseTimer()
            default: break
            }
        }
    }
}

#Preview {
    @Previewable @State var codeWord = CodeWord()
    CodeWordView(codeWord: codeWord)
}
