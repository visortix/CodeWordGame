//
//  KeyView.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 13.12.2025.
//

import SwiftUI

struct KeyView: View {
    // MARK: Data Owned by Me
    let letter: String
    
    // MARK: - Body
    
    var body: some View {
        RoundedRectangle(cornerRadius: Key.cornerRadius)
            .aspectRatio(Key.aspectRatio, contentMode: .fit)
            .foregroundStyle(Color(.systemGray6))
            .shadow(radius: Key.shadowRadius)
            .overlay {
                Text(letter)
                    .foregroundStyle(.black)
                    .font(.headline)
            }
    }
    
    struct Key {
        static let aspectRatio: CGFloat = 2/2.8
        static let cornerRadius: CGFloat = 10
        static let shadowRadius: CGFloat = 1
    }
}

//#Preview {
//    KeyView()
//}
