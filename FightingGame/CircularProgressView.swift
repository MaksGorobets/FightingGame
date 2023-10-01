//
//  CircularProgressView.swift
//  FightingGame
//
//  Created by Maks Winters on 01.10.2023.
//

import SwiftUI

struct CircularProgressView: View {
    
    let progress: Double
    
    var body: some View {
        
        ZStack {
            Circle()
                .stroke(
                    Color.pink.opacity(50), style: StrokeStyle(lineWidth: 5)
                    )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.green.opacity(50),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
    }
}

#Preview {
    CircularProgressView(progress: 0.25)
}
