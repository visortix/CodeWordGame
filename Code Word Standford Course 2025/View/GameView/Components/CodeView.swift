//
//  CodeView.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 28.12.2025.
//

import SwiftUI

struct CodeView: View {
    // MARK: Data In
    @Environment(\.settings) var settings
    let code: Code
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    
    // MARK: Data Owned by Me
    @Namespace private var selectionDotNamespace
    
    init(code: Code, selection: Binding<Int> = .constant(-1)) {
        self.code = code
        self._selection = selection
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            ForEach(code.letters.indices, id: \.self) { index in
                settings.getStrokedShape(lineWidth: GuessLine.matchOutlineLineWidth)
                    .scaleEffect(GuessLine.sectionScale)
                    .foregroundStyle(code.matches?[index].color ?? .clear)
                    .contentShape(Circle())
                    .background {   /// - Guess and .nomatch Outline
                                    /// - Guess Selection Dot
                        guessNomatchOutline(index: index)
                        selectionDot(index: index)
                    }
                    .overlay { /// - Word
                        Text(code.letters[index])
                            .font(.largeTitle)
                    }
                    .onTapGesture { /// - Changes A Seletction
                        if code.kind == .guess {
                            selection = index
                        }
                    }
                    .transition(AnyTransition.opacityBlur())
            }
        }
    }
    
    @ViewBuilder
    func guessNomatchOutline(index: Int) -> some View {
        if  (code.kind == .guess) ||
            (code.matches?[index] == .nomatch) {
            settings.getStrokedShape(lineWidth: GuessLine.guessNomatchOutlineLineWidth)
                .scaleEffect(GuessLine.sectionScale)
                .foregroundStyle(GuessLine.guessNomatchOutlineColor)
        }
    }
    
    func selectionDot(index: Int) -> some View {
        Group {
            if index == selection, code.kind == .guess {
                GeometryReader { proxy in
                    let height = proxy.size.height
                    Circle()
                        .offset(y: GuessLine.selectionDotOffset(forHeight: height))
                        .scaleEffect(GuessLine.selectionDotScale)
                        .matchedGeometryEffect(id: "selectionDot", in: selectionDotNamespace)
                }
            }
        }
        .animation(.selection, value: selection)
    }
    
    struct GuessLine {
        static let bottomPadding: CGFloat = 25
        static let padding = EdgeInsets(top: 0, leading: 0, bottom: bottomPadding, trailing: 0)
        static let selectionDotScale: CGFloat = 0.13
        static func selectionDotOffset(forHeight height: CGFloat) -> CGFloat {
            height * 4.7 }
        static let rectangleCornerRoundness: CGFloat = 0.2
        static let sectionScale: CGFloat = 0.9
        static let guessNomatchOutlineLineWidth: CGFloat = 1
        static let guessNomatchOutlineColor = Color.gray(0.9)
        static let matchOutlineLineWidth: CGFloat = 4
    }
}

//#Preview {
//    CodeView()
//}
