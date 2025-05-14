//
//  GameBoardView.swift
//  GitHubPractice 1
//
//  Created by Damian O. Dudek on 5/5/25.
//

import SwiftUI

struct GameBoardView: View {
    @ObservedObject var gameBoard: GameBoard
    @Binding var gameMode: GameMode

    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<gameBoard.board.count, id: \.self) { row in
                HStack(spacing: 4) {
                    ForEach(0..<gameBoard.board[row].count, id: \.self) { col in
                        CellView(content: gameBoard.board[row][col]) {
                            gameBoard.makeMove(row: row, col: col, gameMode: gameMode)
                        }
                    }
                }
            }
        }
    }
}
