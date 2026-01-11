//
//  ElapsedTime.swift
//  Code Word Standford Course 2025
//
//  Created by visortix on 09.01.2026.
//

import SwiftUI

struct ElapsedTime: View {
    let startTime: Date?
    let endTime: Date?
    let elapsedTime: TimeInterval
    
    func format(_ startTime: Date) -> SystemFormatStyle.DateOffset {
        .offset(to: startTime - elapsedTime, allowedFields: [.minute, .second])
    }
    
    var body: some View {
        if let startTime {
            if let endTime {
                Text(endTime, format: format(startTime))
            } else {
                Text(TimeDataSource<Date>.currentDate, format: format(startTime))
            }
        } else {
            let currentTime = Date.now
            Text(currentTime, format: format(currentTime)).foregroundStyle(.gray)
        }
    }
}

//#Preview {
//    ElapsedTime()
//}
