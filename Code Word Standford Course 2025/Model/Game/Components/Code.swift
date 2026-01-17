//
//  Code.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 29.12.2025.
//

import Foundation
import SwiftData

@Model
class Code {
    var _kind: String = Kind.unknown.description
    var letters: [Letter]
    var word = ""
    var timestamp = Date.now
    
    var kind: Kind {
        get { Kind(_kind) }
        set { _kind = newValue.description }
    }
    
    init(kind: Kind, count: Int) {
        self.letters = Array(repeating: Letter.missing, count: count)
        self.kind = kind
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }
    
    var isEmpty: Bool {
        letters.allSatisfy({$0 == .missing})
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
