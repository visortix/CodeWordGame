//
//  SwiftDataPreview.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 15.01.2026.
//

import SwiftUI
import SwiftData

struct SwiftDataPreview: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(
            for: CodeWord.self, Settings.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        let defaultSettings = Settings()
        container.mainContext.insert(defaultSettings)
        
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait<Preview.ViewTraits> {
    @MainActor static var swiftData: Self = .modifier(SwiftDataPreview())
}
