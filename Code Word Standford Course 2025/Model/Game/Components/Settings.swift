//
//  Settings.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 09.01.2026.
//

import SwiftUI
import SwiftData

@Model
class Settings {
    var wordLength: Int
    var _guessShape: String
    
    var guessShape: ShapeType {
        get { ShapeType(_guessShape) }
        set { _guessShape = newValue.rawValue }
    }
    
    init(wordLength: Int = 3, guessShape: ShapeType = ShapeType.square) {
        self.wordLength = wordLength
        self._guessShape = guessShape.rawValue
    }
}

extension Settings {
    enum ShapeType: String, CaseIterable {
        case circle
        case square
        
        init(_ optionName: String) {
            if optionName == "circle" {
                self = .circle
                return
            }
            if optionName == "square" {
                self = .square
                return
            }
            self = .circle
        }
        
        @ViewBuilder
        func getStrokedShape(lineWidth: CGFloat) -> some View {
            switch self {
            case .circle:
                Circle().stroke(style: StrokeStyle(lineWidth: lineWidth))
            case .square:
                GeometryReader { proxy in
                    let height: CGFloat = proxy.size.height
                    
                    RoundedRectangle(cornerRadius: height * CodeView.GuessLine.rectangleCornerRoundness)
                        .stroke(style: StrokeStyle(lineWidth: lineWidth))
                }
                .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}
