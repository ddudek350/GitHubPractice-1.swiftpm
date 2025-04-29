import SwiftUI


struct ContentView: View {
    @State private var board = Array(repeating: Array(repeating: "", count: 3), count: 3)
    @State private var currentPlayer = "X"
    @State private var gameOver = false
    @State private var winner = ""
    @State private var gameMode: GameMode = .playerVsPlayer
    
    enum GameMode {
        case playerVsPlayer
        case playerVsBot
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Tic Tac Toe")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 10)
            
            // Game mode picker
            Picker("Game Mode", selection: $gameMode) {
                Text("2 Players").tag(GameMode.playerVsPlayer)
                Text("vs Computer").tag(GameMode.playerVsBot)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .disabled(gameStarted)
            
            // Game board with visible grid lines
            VStack(spacing: 0) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { col in
                            CellView(content: board[row][col]) {
                                makeMove(row: row, col: col)
                            }
                            .border(Color.gray, width: 1) // Grid lines
                        }
                    }
                }
            }
            .background(Color.black) // Background for the grid
            .padding()
            .disabled(gameMode == .playerVsBot && currentPlayer == "O")
            
            // Game status
            if gameOver {
                VStack {
                    Text(winner.isEmpty ? "It's a draw!" : "\(winner) wins!")
                        .font(.title)
                        .padding(.bottom, 10)
                    
                    Button(action: resetGame) {
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
                Text(currentTurnText)
                    .font(.title2)
                    .foregroundColor(currentPlayer == "X" ? .blue : .red)
            }
        }
        .frame(width: 300, height: 500)
        .onChange(of: gameMode) { _ in
            resetGame()
        }
    }
    
    // Cell view component
    struct CellView: View {
        let content: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(content)
                    .font(.system(size: 50, weight: .bold))
                    .frame(width: 80, height: 80)
                    .background(Color.white)
                    .foregroundColor(content == "X" ? .blue : .red)
            }
            .disabled(content != "")
        }
    }
    
    private var gameStarted: Bool {
        return board.flatMap { $0 }.contains { !$0.isEmpty }
    }
    
    private var currentTurnText: String {
        if gameMode == .playerVsBot && currentPlayer == "O" {
            return "Computer's turn"
        }
        return "Player \(currentPlayer)'s turn"
    }
    
    private func makeMove(row: Int, col: Int) {
        guard board[row][col].isEmpty else { return }
        
        board[row][col] = currentPlayer
        
        if checkWin() {
            winner = gameMode == .playerVsBot && currentPlayer == "O" ? "Computer" : "Player \(currentPlayer)"
            gameOver = true
            return
        }
        
        if checkDraw() {
            gameOver = true
            return
        }
        
        currentPlayer = currentPlayer == "X" ? "O" : "X"
        
        // If playing vs bot and it's bot's turn
        if gameMode == .playerVsBot && currentPlayer == "O" && !gameOver {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                makeBotMove()
            }
        }
    }
    
    private func makeBotMove() {
        let bestMove = findBestMove()
        makeMove(row: bestMove.row, col: bestMove.col)
    }
    
    private func findBestMove() -> (row: Int, col: Int) {
        // 1. Check if bot can win
        for i in 0..<3 {
            for j in 0..<3 {
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
        
        // 2. Check if need to block player
        for i in 0..<3 {
            for j in 0..<3 {
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
        
        // 3. Try to take center
        if board[1][1].isEmpty {
            return (1, 1)
        }
        
        // 4. Take a random available spot
        var emptySpots = [(Int, Int)]()
        for i in 0..<3 {
            for j in 0..<3 {
                if board[i][j].isEmpty {
                    emptySpots.append((i, j))
                }
            }
        }
        
        return emptySpots.randomElement() ?? (0, 0)
    }
    
    private func checkWin() -> Bool {
        // Check rows
        for row in board {
            if row[0] != "" && row[0] == row[1] && row[1] == row[2] {
                return true
            }
        }
        
        // Check columns
        for col in 0..<3 {
            if board[0][col] != "" && board[0][col] == board[1][col] && board[1][col] == board[2][col] {
                return true
            }
        }
        
        // Check diagonals
        if board[0][0] != "" && board[0][0] == board[1][1] && board[1][1] == board[2][2] {
            return true
        }
        
        if board[0][2] != "" && board[0][2] == board[1][1] && board[1][1] == board[2][0] {
            return true
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
    
    private func resetGame() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3)
        currentPlayer = "X"
        gameOver = false
        winner = ""
    }
}

