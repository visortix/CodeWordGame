//
//  GameCenter.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 31.12.2025.
//

import SwiftUI
import SwiftData

struct GameCenter: View {
    // MARK: Data In
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data Owned by Me
    @State private var selection: CodeWord? = nil
    @State private var showSettings = false
    @State private var search = ""
    @State private var filterOption: GameList.FilterOption = .all
    
    var body: some View {
        NavigationSplitView {
            Picker("Filter", selection: $filterOption) {
                ForEach(GameList.FilterOption.allCases, id: \.self) { option in
                    Text(option.title)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            GameList(guessesContain: search, filterOption: filterOption, selection: $selection, showSettings: $showSettings)
                .navigationTitle("Game Center")
                .searchable(text: $search)
        } detail: {
            if let selection {
                CodeWordView(codeWord: selection)
                    .navigationTitle(selection.isGameOver ? "Game Over" : "Code Word")
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Start new game to see")
            }
        }
        .onAppear {
            initSettings()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    func initSettings() {
        let fetchDescriptor = FetchDescriptor<Settings>()
        let results = try? modelContext.fetch(fetchDescriptor)
        
        if results?.count == 0 {
            modelContext.insert(Settings())
        }
    }
}

#Preview(traits: .swiftData) {
    GameCenter()
}
