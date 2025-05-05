//
//  ContentView.swift
//  GitHubPractice 1
//
//  Created by Damian O. Dudek on 5/5/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var gameBoard = GameBoard()
    @State private var gameMode: GameMode = .playerVsPlayer
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Tic Tac Toe")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 10)
            
            GameModePicker(gameMode: $gameMode, gameStarted: gameBoard.gameStarted)
            
            GameBoardView(gameBoard: gameBoard, gameMode: $gameMode)
            Text("Time left: \(gameBoard.timeLeft)s")
                .font(.headline)
            
            GameStatusView(gameBoard: gameBoard, gameMode: $gameMode)
            
        }
        .frame(width: 300, height: 500)
        .onChange(of: gameMode) {
            gameBoard.resetGame()
        }
    }
}
