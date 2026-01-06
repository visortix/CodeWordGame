//
//  CodeView.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 28.12.2025.
//

import SwiftUI

struct CodeView: View {
    // MARK: Data In
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
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 4))
                    .scaleEffect(0.9)
                    .contentShape(Circle())
                    .foregroundStyle(code.matches?[index].color ?? .clear)
                    .background { /// - Code Matches and Selection Dot
                        if (code.kind == .guess) ||
                            (code.matches?[index] == .nomatch) {
                            Circle().stroke(Color.gray(0.9))
                        }
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
                    .transition(AnyTransition.opacityBlur)
            }
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
            height * 4.7
        }
    }
}

//#Preview {
//    CodeView()
//}
