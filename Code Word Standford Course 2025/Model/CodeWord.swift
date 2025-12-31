//
//  CodeWord.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 12.12.2025.
//

import SwiftUI

struct CodeWord {
    var masterCode: Code {
        didSet {
            self.guess = Code(kind: .guess, count: self.count)
        } 
    }
    var guess: Code
    var attempts: [Code] = []
    let choices: [Letter]
    var slotLetterStatuses = [Int: [Letter: Match]]()
    @State private var checker = UITextChecker()
    
    init() {
        self.masterCode = Code(kind: .master, count: 4)
        self.choices = "QWERTYUIOPASDFGHJKLZXCVBNM".map { String($0) }
        self.guess = Code(kind: .guess, count: 4)
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
    
    var isGuessEmpty: Bool {
        guess.letters.allSatisfy(\.isEmpty)
    }
    
    var count: Int {
        masterCode.letters.count
    }
    
    mutating func makeAttempt() {
        let guessString = guess.letters.joined().lowercased()
        guard guessString.count == count else { return }
        guard checker.isAWord(guessString) else { return }
        
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        
        if let matches = attempt.matches {
            for index in matches.indices {
                let letter = attempt.letters[index]
                let match = matches[index]
                var lettersStatus = slotLetterStatuses[index, default: [:]]
                lettersStatus[letter] = match
                slotLetterStatuses[index] = lettersStatus
            }
        }
        if isGameOver {
            guess.letters.clear()
        }
    }
    
    mutating func restart() {
        self = CodeWord()
    }
}


