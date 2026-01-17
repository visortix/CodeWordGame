//
//  Kind.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 14.01.2026.
//

import Foundation

extension Code {
    enum Kind: Equatable, CustomStringConvertible {
        case master
        case guess
        case attempt([Match])
        case unknown

        // MARK: - CustomStringConvertible

        var description: String {
            switch self {
            case .master:
                return "master"
            case .guess:
                return "guess"
            case .attempt(let matches):
                let matchStr = matches.map { $0.rawValue }.joined(separator: ",")
                return "attempt(\(matchStr))"
            case .unknown:
                return "unknown"
            }
        }

        // MARK: - Non-Failable Initializer

        init(_ string: String) {
            if string == "master" {
                self = .master
                return
            }
            
            if string == "guess" {
                self = .guess
                return
            }

            if string == "unknown" {
                self = .unknown
                return
            }

            if string.hasPrefix("attempt("), string.hasSuffix(")") {
                let inner = String(string.dropFirst("attempt(".count).dropLast())
                let matchStrings = inner.split(separator: ",").map(String.init)
                let matches = matchStrings.compactMap { Match(rawValue: $0) }
                self = .attempt(matches)
                return
            }

            self = .unknown
        }
    }
}
