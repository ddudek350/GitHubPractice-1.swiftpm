import SwiftUI
import Combine

enum Player: String {
    case x = "X"
    case o = "O"

    var next: Player { self == .x ? .o : .x }
    var color: Color { self == .x ? .red : .blue }
}

@MainActor
class GameBoard: ObservableObject {
    @Published var board: [[Player?]]
    @Published var currentPlayer: Player
    @Published var gameOver = false
    @Published var winner: Player?
    @Published var timeLeft: Int = 5
    @Published var winLength: Int = 3
    private var isActive = false
    private var moveTimer: AnyCancellable?

    init(gameMode: GameMode) {
        self.currentPlayer = Bool.random() ? .x : .o
        self.board = Array(repeating: Array(repeating: nil, count: 3), count: 3)
    }

    func startNewGame(gameMode: GameMode) {
        isActive = true
        winLength = 3
        board = Array(repeating: Array(repeating: nil, count: winLength), count: winLength)
        currentPlayer = Bool.random() ? .x : .o
        gameOver = false
        winner = nil
        timeLeft = 5
        moveTimer?.cancel()
        handleNextMove(gameMode: gameMode)
    }

    func makeMove(row: Int, col: Int, gameMode: GameMode) {
        guard isActive, !gameOver, board[row][col] == nil else { return }
        board[row][col] = currentPlayer
        moveTimer?.cancel()

        if checkWin(from: (row, col)) {
            winner = currentPlayer
            gameOver = true
            return
        }

        if checkDraw() {
            expandBoardIfNeeded()
            switchPlayer()
            handleNextMove(gameMode: gameMode)
            return
        }

        switchPlayer()
        handleNextMove(gameMode: gameMode)
    }

    private func handleNextMove(gameMode: GameMode) {
        guard isActive else { return }
        if gameMode == .playerVsBot && currentPlayer == .o {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.makeBotMove(gameMode: gameMode)
            }
        } else {
            startTimer(gameMode: gameMode)
        }
    }

    private func startTimer(gameMode: GameMode) {
        guard isActive else { return }
        timeLeft = 5
        moveTimer?.cancel()
        moveTimer = Timer.publish(every: 1, on: .main, in: .common)
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
        guard isActive, !gameOver else { return }
        let emptyCells = board.enumerated().flatMap { row, cols in
            cols.enumerated().compactMap { col, player in
                player == nil ? (row, col) : nil
            }
        }
        if let (row, col) = emptyCells.randomElement() {
            makeMove(row: row, col: col, gameMode: gameMode)
        }
    }

    private func makeBotMove(gameMode: GameMode) {
        makeRandomMove(gameMode: gameMode)
    }

    private func checkWin(from lastMove: (Int, Int)) -> Bool {
        let directions = [(1,0), (0,1), (1,1), (1,-1)]
        for (dx, dy) in directions {
            var count = 1
            count += countConsecutive(from: lastMove, delta: (dx, dy))
            count += countConsecutive(from: lastMove, delta: (-dx, -dy))
            if count >= winLength {
                return true
            }
        }
        return false
    }

    private func countConsecutive(from start: (Int, Int), delta: (Int, Int)) -> Int {
        var count = 0
        var position = (start.0 + delta.0, start.1 + delta.1)
        while position.0 >= 0 && position.0 < board.count &&
              position.1 >= 0 && position.1 < board.count &&
              board[position.0][position.1] == currentPlayer {
            count += 1
            position = (position.0 + delta.0, position.1 + delta.1)
        }
        return count
    }

    private func checkDraw() -> Bool {
        return !board.flatMap { $0 }.contains(nil)
    }

    private func expandBoardIfNeeded() {
        let oldSize = board.count
        let newSize = oldSize + 2
        let emptyRow = Array<Player?>(repeating: nil, count: newSize)
        var newBoard = [emptyRow]
        for row in board {
            newBoard.append([nil] + row + [nil])
        }
        newBoard.append(emptyRow)
        board = newBoard
        if winLength < 4 {
            winLength = 4
        }
    }

    private func switchPlayer() {
        currentPlayer = currentPlayer.next
    }
}
