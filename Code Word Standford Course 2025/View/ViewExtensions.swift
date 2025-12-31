//
//  ViewExtensions.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 28.12.2025.
//

import SwiftUI

extension Animation {
    static let codeBreaker = Animation.bouncy(duration: 0.5)
    static let guess = codeBreaker
    static let restart = codeBreaker
    static let delete = codeBreaker
    static let selection = codeBreaker
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        Color(hue: 12/360, saturation: 0, brightness: brightness)
    }
}

struct Blur: AnimatableModifier {
    init(radius: Double = 0) { animatableData = radius }
    var animatableData: Double

    func body(content: Content) -> some View {
        content.blur(radius: animatableData)
    }
}

extension AnyTransition {
    static let keyboard = AnyTransition.offset(y: 200).combined(with: .opacityBlur)
    static let guess = AnyTransition.asymmetric(
        insertion: .opacity.combined(with: .blur(50)),
        removal: .identity
    )
    static let deleteButton = AnyTransition.offset(y: 200).combined(with: .opacityBlur)
    static let guessButton = deleteButton
    static func attempt(_ isGameOver: Bool) -> AnyTransition {
        .asymmetric(
            insertion: isGameOver ? .identity : .move(edge: .top).combined(with: opacityBlur),
            removal: .move(edge: .trailing).combined(with: opacityBlur)
        )
    }
}

extension AnyTransition {
    static let blur = AnyTransition.modifier(active: Blur(radius: 10.0), identity: .init())
    static func blur(_ radius: Double) -> AnyTransition {
        AnyTransition.modifier(active: Blur(radius: radius), identity: .init())
    }
    static let opacityBlur = AnyTransition.opacity.combined(with: .blur)
}


