C//
//  ControlPanel.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 28.12.2025.
//

import SwiftUI

struct ControlPanel: View {
    // MARK: Data In
    let isGameOver: Bool
    
    // MARK: Data Shared with Me
    @Binding var restarting: Bool
    
    // MARK: Data Out Function
    let onRestart: () -> Void
    let onDelete: () -> Void
    let onGuess: () -> Void
    let fillGameCode: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            Button {
                withAnimation(.restart) {
                    restarting = true
                    onRestart()
                } completion: {
                    withAnimation(.restart) {
                        restarting = false
                    }
                }
            } label: {
                Text("🔴")
            }
            .contrast(0)
            .disabled(true)
            Spacer()
            if !isGameOver {
                Button {
                    withAnimation(.delete) {
                        onDelete()
                    }
                } label: {
                    Text("🟡")
                }
                .transition(.deleteButton)
                Button {
                    withAnimation(.guess) {
                        onGuess()
                    }
                } label: {
                    Text("🟢")
                }
                .transition(.guessButton)
            }
        }
//        .transaction { transaction in
//            transaction.animation = transaction.animation?.delay(3)
//        }
        .font(.title)
    }
}

//#Preview {
//    ControlPanel()
//}
