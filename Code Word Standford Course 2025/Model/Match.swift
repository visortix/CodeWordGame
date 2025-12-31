//
//  Match.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 29.12.2025.
//

import SwiftUI

enum Match {
    case nomatch
    case exact
    case inexact
    
    var color: Color {
        switch self {
        case .nomatch: return .clear
        case .exact: return .primary
        case .inexact: return Color.gray(0.9)
        }
    }
}
