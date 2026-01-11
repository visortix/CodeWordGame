//
//  CodeWord.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 12.12.2025.
//

import SwiftUI

@Observable
class CodeWord {
    var masterCode: Code {
        didSet {
            self.guess = Code(kind: .guess, count: self.count)
        }
    }
    var guess: Code
    var attempts: [Code] = []
    let choices: [Letter]
    var slotLetterStatuses = [Int: [Letter: Match]]()
    private var checker = UITextChecker()
    let customLenght: Int?
    
    // MARK: Time
    var initDate: Date
    var startTime: Date?
    var endTime: Date? = nil
    var elapsedTime: TimeInterval = 0
    
    var lastAttemptDate: Date?
    
    // MARK: - Init
    
    init(length: Int? = nil) {
        self.customLenght = length
        let length = length ?? 4
        
        self.masterCode = Code(kind: .master, count: length)
        self.choices = "QWERTYUIOPASDFGHJKLZXCVBNM".map { String($0) }
        self.guess = Code(kind: .guess, count: length)
        self.initDate = .now
    }
    
    var isGameOver: Bool {
        let lastAttempt = attempts.last?.matches
        
        if let lastAttempt {
            if lastAttempt.allSatisfy({ $0 == .exact }) {
                return true
            }
        }
        return false
    }
    
    // MARK: - Computed Properties
    
    var isGuessEmpty: Bool {
        guess.letters.allSatisfy(\.isEmpty)
    }
    
    /// Count of letters in the master code
    var count: Int {
        masterCode.letters.count
    }
    
    // MARK: - Logic
    
    func startTimer() {
       if startTime == nil, !isGameOver {
            startTime = .now
        }
    }

    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
    /// Appends a valid word to the attempts and some more
    func makeAttempt() {
        guard (guess.letters.count == masterCode.letters.count) else { return }

        let guessString = guess.letters.joined().lowercased()
        guard checker.isAWord(guessString) else { return }
    
        appendAttempt()
        
        appendSlotLetterStatuses(attempt: attempts.last!)
        if isGameOver { /// - Clears guess line if game is over
            guess.letters.clear()
        }
        lastAttemptDate = .now
    }
    
    /// + Appends a guess to the attempts
    func appendAttempt() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
    }
    
    /// + Appends a match for each letter in each position of the Code word
    func appendSlotLetterStatuses(attempt: Code) {
        if let matches = attempt.matches { /// - If matches exist
            for index in matches.indices { /// - Iterate through the matches' indices
                /// - Find letter and match marker for the position
                let letter = attempt.letters[index]
                let match = matches[index]
                /// - Creates dictionary [letter:  match]
                var lettersStatus = slotLetterStatuses[index, default: [:]]
                lettersStatus[letter] = match
                /// - Adds [letter: match] to the [index: [letter: match]] dictionary
                slotLetterStatuses[index] = lettersStatus
            }
        }
    }
    
    /// 🔁 Restarts the game by creating a new instance
    func restart() {
        let newGame = CodeWord(length: count)
        
        self.masterCode = newGame.masterCode
        self.guess = newGame.guess
        self.attempts = newGame.attempts
        self.slotLetterStatuses = newGame.slotLetterStatuses
    }
}

/// 🧩 Adds conformance to Identifiable, Hashable, and Equatable
extension CodeWord: Identifiable, Hashable, Equatable {
    /// Requirement for Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    /// Requirement for Equatable
    static func == (lhs: CodeWord, rhs: CodeWord) -> Bool {
        lhs.id == rhs.id
    }
}
