//
//  Color+.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 06.01.2026.
//

import SwiftUI

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        Color(hue: 12/360, saturation: 0, brightness: brightness)
    }
}
