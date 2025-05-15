import SwiftUI

struct ContentView: View {
    @State private var gameStarted = false
    @State private var gameMode: GameMode = .playerVsPlayer
    @StateObject private var gameBoard = GameBoard(gameMode: .playerVsPlayer)

    var body: some View {
        VStack(spacing: 16) {
            Text("Tic-Tac-Toe")
                .font(.largeTitle)
                .padding(.bottom, 30)

            GameModePicker(
                gameMode: $gameMode,
                gameStarted: gameBoard.board.flatMap { $0 }.contains { $0 != nil }
            )
            .padding(.bottom, 20)

            GameBoardView(gameBoard: gameBoard, gameMode: $gameMode)
                            .disabled(!gameStarted)

            if gameStarted {
                GameStatusView(gameBoard: gameBoard, gameMode: $gameMode)
            } else {
                Button("Start Game") {
                    gameStarted = true
                    gameBoard.startNewGame(gameMode: gameMode)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .onChange(of: gameMode) { newMode in
            gameBoard.startNewGame(gameMode: newMode)
        }
        .animation(.default, value: gameStarted)
    }
}
