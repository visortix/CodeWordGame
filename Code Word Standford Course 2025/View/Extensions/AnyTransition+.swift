//
//  AnyTransition.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 06.01.2026.
//

import SwiftUI

/// Constants
extension AnyTransition {
    
    /// Control Panel
    static let keyboard = Self.offsetOpacityBlur
    static let deleteButton = Self.offsetOpacityBlur
    static let guessButton = deleteButton
    
    /// Code Views
    static let guess = AnyTransition.asymmetric(
        insertion: .opacityBlur(50),
        removal: .identity
    )
    static func attempt(_ isGameOver: Bool) -> AnyTransition {
        .asymmetric(
            insertion: (isGameOver ?
                .identity : .moveOpacityBlur(edge: .top)),
            removal: .moveOpacityBlur(edge: .trailing)
        )
    }
}

/// Combined transitions
extension AnyTransition {
    static func opacityBlur(_ radius: Double = 10) -> Self {
        .opacity.combined(with: .blur(radius))
    }
    static let offsetOpacityBlur = Self.offset(y: 200).combined(with: .opacityBlur())
    static func moveOpacityBlur(edge: Edge) -> Self {
        .move(edge: edge).combined(with: opacityBlur())
    }
}

/// Blur transition addition
extension AnyTransition {
    static let blur = AnyTransition.modifier(active: Blur(radius: 10.0), identity: .init())
    static func blur(_ radius: Double) -> AnyTransition {
        AnyTransition.modifier(active: Blur(radius: radius), identity: .init())
    }
}

struct Blur: AnimatableModifier {
    init(radius: Double = 0) { animatableData = radius }
    var animatableData: Double

    func body(content: Content) -> some View {
        content.blur(radius: animatableData)
    }
}
