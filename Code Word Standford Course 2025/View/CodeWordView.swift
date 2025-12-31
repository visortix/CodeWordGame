//
//  CodeWordView.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 12.12.2025.
//

import SwiftUI
import GameKit

struct CodeWordView: View {
    // MARK: Data In
    @Environment(\.words) var words
    
    // MARK: Data Owned by Me
    @State private var codeWord = CodeWord()
    @State private var selection = 0
    @State private var restarting = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Group {
                if !restarting {
                    CodeView(code: codeWord.masterCode)
                        .blur(radius: codeWord.isGameOver ? 0 : 10)
                        .transition(.opacityBlur)
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
        .padding()
        .onChange(of: words.count, initial: true) {
            if codeWord.attempts.isEmpty {
                if words.count == 0 {
                    codeWord.masterCode.letters = ["W", "A", "I", "T"]
                } else {
                    fillGameCode()
                }
            }
        }
    }
    
    // MARK: - Logic Functions
    
    func fillGameCode() {
        let randomCount = 3 + GKRandomSource.sharedRandom().nextInt(upperBound: (3 + 1))
        codeWord.masterCode.letters = (words.random(length: randomCount) ?? "ERROR").map { String($0) }
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
}


#Preview {
    CodeWordView()
}
