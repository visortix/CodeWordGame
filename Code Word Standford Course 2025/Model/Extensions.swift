//
//  Extensions.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 29.12.2025.
//

typealias Letter = String

extension Letter {
    static let missing = ""
}

extension Array where Element == Letter {
    mutating func clear() {
        self = Array(repeating: "", count: self.count)
    }
}

