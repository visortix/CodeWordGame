//
//  Settings.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 09.01.2026.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var settings = Settings.shared
}

@Observable
class Settings {
    var wordLength = 3
    var guessShape = ShapeType.square
    let defaults = UserDefaults()
        
    static var shared = Settings()
    
    init() {
        var wordLength = defaults.integer(forKey: "wordLength")
        wordLength = (wordLength == 0) ? 3 : wordLength
        let guessShape = defaults.string(forKey: "guessShape") ?? ShapeType.square.rawValue
        
        self.wordLength = wordLength
        self.guessShape = ShapeType(rawValue: guessShape)!
    }
    
    func save() {
        defaults.set(self.wordLength, forKey: "wordLength")
        defaults.set(self.guessShape.rawValue, forKey: "guessShape")
    }
    
    @ViewBuilder
    func getStrokedShape(lineWidth: CGFloat) -> some View {
        switch self.guessShape {
        case .circle:
            Circle()
                .stroke(style: StrokeStyle(lineWidth: lineWidth))
        case .square:
            GeometryReader { proxy in
                let height: CGFloat = proxy.size.height
                
                RoundedRectangle(cornerRadius: height * CodeView.GuessLine.rectangleCornerRoundness)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth))
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
    
    enum ShapeType: String, CaseIterable {
        case circle
        case square
    }
}
