//
//  ElapsedTimeTracker.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 17.01.2026.
//

import SwiftUI
import SwiftData

extension View {
    func trackElapsedTime(in codeWord: CodeWord) -> some View {
        self.modifier(ElapsedTimeTracker(game: codeWord))
    }
}

struct ElapsedTimeTracker: ViewModifier {
    @Environment(\.modelContext) var modelContext
    @Environment(\.scenePhase) var scenePhase
    let game: CodeWord
    
    var modelContextWillSavePublisher: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(
            for: ModelContext.willSave,
            object: modelContext
        )
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                game.startTimer()
            }
            .onDisappear {
                print("- disappear")
                game.pauseTimer()
            }
            .onChange(of: game) { oldGame, newGame in
                oldGame.pauseTimer()
                newGame.startTimer()
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .active: game.startTimer()
                case .background: game.pauseTimer(); print("- background")
                default: break
                }
            }
            .onReceive(modelContextWillSavePublisher) { _ in
                game.updateElapsedTime()
                print("updated elapsed time to \(game.elapsedTime)")
            }
    }
}
