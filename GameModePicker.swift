//
//  GameModePicker.swift
//  GitHubPractice 1
//
//  Created by Grigorii V. Chushkin on 5/5/25.
//

import SwiftUI

struct GameModePicker: View {
    @Binding var gameMode: GameMode
    let gameStarted: Bool
    
    var body: some View {
        Picker("Game Mode", selection: $gameMode) {
            Text("2 Players").tag(GameMode.playerVsPlayer)
            Text("vs Computer").tag(GameMode.playerVsBot)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
        .disabled(gameStarted)
    }
}
