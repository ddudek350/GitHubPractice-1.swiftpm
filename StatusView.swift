//
//  StatusView.swift
//  GitHubPractice 1
//
//  Created by Damian O. Dudek on 5/5/25.
//

import SwiftUI

struct GameStatusView: View {
    @ObservedObject var gameBoard: GameBoard
    @Binding var gameMode: GameMode
    
    var body: some View {
        if gameBoard.gameOver {
            VStack {
                Text(gameBoard.winner.isEmpty ? "It's a draw!" : "\(winnerText()) wins!")
                    .font(.title)
                    .padding(.bottom, 10)
                
                Button(action: gameBoard.resetGame(gameMode: gameMode)) {
                    Text("Play Again")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .frame(width: 200)
            }
        } else {
            Text(currentTurnText())
                .font(.title2)
                .foregroundColor(gameBoard.currentPlayer == "X" ? .blue : .red)
        }
    }
    
    private func winnerText() -> String {
        if gameMode == .playerVsBot && gameBoard.winner == "O" {
            return "Computer"
        } else {
            return "Player \(gameBoard.winner)"
        }
    }
    
    private func currentTurnText() -> String {
        switch gameMode {
        case .playerVsPlayer:
            return "Player \(gameBoard.currentPlayer)'s turn"
        case .playerVsBot:
            return gameBoard.currentPlayer == "O" ? "Computer's turn" : "Your turn"
        }
    }
}
