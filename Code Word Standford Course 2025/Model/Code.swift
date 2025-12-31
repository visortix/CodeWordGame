//
//  Code.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 29.12.2025.
//

import Foundation

struct Code {
    var kind: Kind
    var letters: [Letter]
    
    init(kind: Kind, count: Int) {
        self.kind = kind
        self.letters = Array(repeating: Letter.missing, count: count)
    }
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var pegsToMatch = otherCode.letters
        var result = [Match](repeating: .nomatch, count: letters.count)
        
        for (index, letter) in letters.enumerated().reversed() {
            if pegsToMatch[index] == letter {
                result[index] = .exact
                pegsToMatch.remove(at: index)
            }
            
        }
        
        for (index, letter) in letters.enumerated() {
            if let pegIndex = pegsToMatch.firstIndex(of: letter), result[index] == .nomatch {
                result[index] = .inexact
                pegsToMatch.remove(at: pegIndex)
            }
        }
        
        return result
    }
}
