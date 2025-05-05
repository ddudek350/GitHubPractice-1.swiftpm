//
//  GameBoard.swift
//  GitHubPractice 1
//
//  Created by Grigorii V. Chushkin on 5/5/25.
//

import Foundation
import Combine

class GameBoard: ObservableObject {
    @Published var board: [[String]]
    @Published var currentPlayer = "X"
    @Published var gameOver = false
    @Published var winner = ""
    @Published var timeLeft: Int = 5
    @Published var winLength = 3

    private var boardSize = 3
    private var moveTimer: AnyCancellable?
    
    init() {
        board = Array(repeating: Array(repeating: "", count: boardSize), count: boardSize)
    }
    
    var gameStarted: Bool {
        return board.flatMap { $0 }.contains { !$0.isEmpty }
    }
    
    func makeMove(row: Int, col: Int, gameMode: GameMode) {
        guard board[row][col].isEmpty, !gameOver else { return }
        
        board[row][col] = currentPlayer
        
        if checkWin() {
            winner = currentPlayer
            gameOver = true
            moveTimer?.cancel()
            return
        }
        
        if checkDraw() {
            if !checkWin() {
                expandBoard()
                return
            } else {
                gameOver = true
                moveTimer?.cancel()
                return
            }
        }
        
        currentPlayer = currentPlayer == "X" ? "O" : "X"
        
        if gameMode == .playerVsBot && currentPlayer == "O" && !gameOver {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.makeBotMove(gameMode: gameMode)
            }
        } else if !gameOver {
            startTimer(gameMode: gameMode)
        }
    }
    
    private func makeBotMove(gameMode: GameMode) {
        let bestMove = findBestMove()
        makeMove(row: bestMove.row, col: bestMove.col, gameMode: gameMode)
    }
    
    private func findBestMove() -> (row: Int, col: Int) {
        for i in 0..<boardSize {
            for j in 0..<boardSize {
                if board[i][j].isEmpty {
                    board[i][j] = "O"
                    if checkWin() {
                        board[i][j] = ""
                        return (i, j)
                    }
                    board[i][j] = ""
                }
            }
        }
        
        for i in 0..<boardSize {
            for j in 0..<boardSize {
                if board[i][j].isEmpty {
                    board[i][j] = "X"
                    if checkWin() {
                        board[i][j] = ""
                        return (i, j)
                    }
                    board[i][j] = ""
                }
            }
        }
        
        if boardSize > 1 && board[boardSize/2][boardSize/2].isEmpty {
            return (boardSize/2, boardSize/2)
        }
        
        var emptySpots = [(Int, Int)]()
        for i in 0..<boardSize {
            for j in 0..<boardSize {
                if board[i][j].isEmpty {
                    emptySpots.append((i, j))
                }
            }
        }
        
        return emptySpots.randomElement() ?? (0, 0)
    }
    
    func checkWin() -> Bool {
        let directions = [
            (dx: 1, dy: 0),  
            (dx: 0, dy: 1),
            (dx: 1, dy: 1),
            (dx: 1, dy: -1)
        ]
        
        for row in 0..<board.count {
            for col in 0..<board[row].count {
                let symbol = board[row][col]
                guard !symbol.isEmpty else { continue }
                
                for dir in directions {
                    var count = 1
                    
                    for step in 1..<winLength {
                        let newRow = row + dir.dy * step
                        let newCol = col + dir.dx * step
                        
                        if newRow >= 0, newRow < board.count,
                           newCol >= 0, newCol < board[row].count,
                           board[newRow][newCol] == symbol {
                            count += 1
                        } else {
                            break
                        }
                    }
                    
                    if count >= winLength {
                        return true
                    }
                }
            }
        }
        
        return false
    }

    
    private func checkDraw() -> Bool {
        for row in board {
            for cell in row {
                if cell.isEmpty {
                    return false
                }
            }
        }
        return true
    }
    
    private func expandBoard() {
        boardSize += 2
        for i in 0..<board.count {
            board[i].insert("", at: 0)
            board[i].append("")
        }
        
        let newRow = Array(repeating: "", count: boardSize)
        board.insert(newRow, at: 0)
        board.append(newRow)
        timeLeft = 5
    }


    
    func resetGame() {
        boardSize = 3
        board = Array(repeating: Array(repeating: "", count: boardSize), count: boardSize)
        currentPlayer = "X"
        gameOver = false
        winner = ""
        timeLeft = 5
        moveTimer?.cancel()
    }
    
    private func startTimer(gameMode: GameMode) {
        timeLeft = 5
        moveTimer?.cancel()
        moveTimer = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.timeLeft -= 1
                if self.timeLeft <= 0 {
                    self.moveTimer?.cancel()
                    self.makeRandomMove(gameMode: gameMode)
                }
            }
    }
    
    private func makeRandomMove(gameMode: GameMode) {
        guard !gameOver else { return }
        var emptySpots = [(Int, Int)]()
        for i in 0..<boardSize {
            for j in 0..<boardSize {
                if board[i][j].isEmpty {
                    emptySpots.append((i, j))
                }
            }
        }
        
        if let move = emptySpots.randomElement() {
            makeMove(row: move.0, col: move.1, gameMode: gameMode)
        }
    }
}

