import SwiftUI

struct ContentView: View {
    @StateObject private var gameBoard = GameBoard(gameMode: .playerVsPlayer)
    @State private var gameMode: GameMode = .playerVsPlayer

    var body: some View {
        VStack(spacing: 16) {
            Text("Tic-Tac-Toe")
                .font(.largeTitle)
                .padding(.top)

            GameModePicker(
                gameMode: $gameMode,
                gameStarted: gameBoard.board.flatMap { $0 }.contains { $0 != nil }
            )

            GameBoardView(gameBoard: gameBoard, gameMode: $gameMode)

            GameStatusView(gameBoard: gameBoard, gameMode: $gameMode)
        }
        .padding()
        .onChange(of: gameMode) { newMode in
            gameBoard.startNewGame(gameMode: newMode)
        }
    }
}