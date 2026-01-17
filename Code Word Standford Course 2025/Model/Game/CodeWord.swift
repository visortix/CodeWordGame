//
//  CodeWord.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 12.12.2025.
//

import SwiftUI
import SwiftData

@Model
class CodeWord {
    
    // MARK: Codes
    @Relationship(deleteRule: .cascade) var masterCode: Code {
        didSet {
            self.guess = Code(kind: .guess, count: self.count)
        }
    }
    @Relationship(deleteRule: .cascade) var guess: Code
    @Relationship(deleteRule: .cascade) var _attempts: [Code] = []
    var attempts: [Code] {
        get { _attempts.sorted { $0.timestamp < $1.timestamp } }
        set { _attempts = newValue }
    }
    
    // MARK: Alphabet
    var choices: [Letter]

    // MARK: Time
    var initDate: Date
    @Transient var startTime: Date?
    var endTime: Date? = nil
    var elapsedTime: TimeInterval = 0
    
    var lastAttemptDate: Date?
    
    // MARK: Other Data
    var slotLetterStatusesData = Data()
    var slotLetterStatuses: [Int: [Letter: Match]] {
        get {
            guard !slotLetterStatusesData.isEmpty else { return [:] }
            return (try? JSONDecoder().decode([Int: [Letter: Match]].self, from: slotLetterStatusesData)) ?? [:]
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                slotLetterStatusesData = data
            }
        }
    }
    @Transient private var checker = UITextChecker()
    var customLenght: Int?
    var isGameOver: Bool = false
    
    // MARK: - Init
    
    init(length: Int? = nil) {
        self.customLenght = length
        let length = length ?? 4
        
        self.masterCode = Code(kind: .master, count: length)
        self.choices = "QWERTYUIOPASDFGHJKLZXCVBNM".map { String($0) }
        self.guess = Code(kind: .guess, count: length)
        self.initDate = .now
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
        print("🟡, start \(masterCode.letters.joined())")
        if startTime == nil, !isGameOver {
            startTime = .now
            elapsedTime += 0.00001
        }
    }

    func pauseTimer() {
        print("🔴, pause \(masterCode.letters.joined())")
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
    func updateElapsedTime() {
        pauseTimer()
        startTimer()
    }
    
    /// Appends a valid word to the attempts and some more
    func makeAttempt() {
        guard (guess.letters.count == masterCode.letters.count) else { return }

        let guessString = guess.letters.joined().lowercased()
        guard checker.isAWord(guessString) else { return }
    
        appendAttempt()
        checkIsGameOver()
        
        appendSlotLetterStatuses(attempt: attempts.last!)
        if isGameOver { /// - Clears guess line if game is over
            guess.letters.clear()
            pauseTimer()
        }
        lastAttemptDate = .now
    }
    
    func checkIsGameOver() {
        let lastAttempt = attempts.last?.matches
        
        if let lastAttempt {
            if lastAttempt.allSatisfy({ $0 == .exact }) {
                isGameOver = true
            }
        }
    }
    
    /// + Appends a guess to the attempts
    func appendAttempt() {
        let attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempt.word = attempt.letters.joined().lowercased()
        attempts.append(attempt)

        self.guess = Code(kind: .guess, count: count)
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
        self.startTime = newGame.startTime
        self.elapsedTime = newGame.elapsedTime
    }
}
