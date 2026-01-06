//
//  Keyboard.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 13.12.2025.
//

import SwiftUI

struct Keyboard: View {
    // MARK: Data In
    let choices: [Letter]
    let slotIndex: Int
    let slotLetterStatuses: [Int: [Letter: Match]]
    
    // MARK: Data Out Function
    let onChoose: (Letter) -> Void
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: KeyLine.spacingVertical) {
            HStack(spacing: KeyLine.spacingHorizontal) {
                keys(from: 0, to: 10)
            }
            HStack(spacing: KeyLine.spacingHorizontal) {
                keys(from: 10, to: 19)
            }
            HStack(spacing: KeyLine.spacingHorizontal) {
                keys(from: 19, to: 26)
            }
        }
        .aspectRatio(KeyboardLimit.aspectRatio, contentMode: .fit)
    }
    
    func keys(from number1: Int, to number2: Int) -> some View {
        ForEach(number1..<number2, id: \.self) { index in
            let letter = choices[index]
            Button {
                onChoose(letter)
            } label: {
                KeyView(letter: letter)
                    .overlay {
                        GeometryReader { proxy in
                            let height = proxy.size.height
                            statusView(at: slotIndex, for: letter)
                                .offset(y: StatusDot.selectionDotOffset(forHeight: height))
                                .scaleEffect(StatusDot.selectionDotScale)
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    func statusView(at index: Int, for letter: Letter) -> some View {
        let lettersStatus = slotLetterStatuses[slotIndex]
        let status = lettersStatus?[letter]
        
        switch status {
        case .exact: Circle()
                .foregroundStyle(.black)
        case .inexact: Circle()
                .foregroundStyle(.gray)
        case .nomatch: Circle()
                .foregroundStyle(.white)
                .shadow(radius: 10)
        case nil: EmptyView()
        }
    }
    
    struct KeyboardLimit {
        static let aspectRatio: CGFloat = 2.6
    }
    struct KeyLine {
        static let spacingVertical: CGFloat = 10
        static let spacingHorizontal: CGFloat = 8
    }
    struct StatusDot {
        static let selectionDotScale: CGFloat = 0.3
        static func selectionDotOffset(forHeight height: CGFloat) -> CGFloat {
            height * 1.55
        }
    }
}

//#Preview {
//    Keyboard()
//}
