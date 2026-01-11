//
//  GameOverview.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 02.01.2026.
//

import SwiftUI

struct GameOverview: View {
    let game: CodeWord
    
    var body: some View {
        VStack(alignment: .leading) {
            CodeView(code: game.attempts.last ?? game.guess)
                .frame(maxHeight: 40)
                .allowsHitTesting(false)
            HStack {
                Text("Number of attempts: \(game.attempts.count)")
                Spacer()
                ElapsedTime(startTime: game.startTime, endTime: game.endTime, elapsedTime: game.elapsedTime)
                    .monospacedDigit()
                    .fixedSize()
            }
        }
    }
}

//#Preview {
//    GameOverview()
//}
