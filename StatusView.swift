import SwiftUI

struct GameStatusView: View {
    @ObservedObject var gameBoard: GameBoard
    @Binding var gameMode: GameMode

    var body: some View {
        VStack {
            if gameBoard.gameOver {
                if let winner = gameBoard.winner {
                    Text("\(winner.rawValue) wins!")
                        .font(.headline)
                } else {
                    Text("It's a draw!")
                        .font(.headline)
                }

                Button("New Game") {
                    gameBoard.startNewGame(gameMode: gameMode)
                }
                .padding(.top)
            } else {
                Text(currentTurnText())
                    .font(.subheadline)

                HStack {
                    Text("Time left:")
                    Text("\(gameBoard.timeLeft)s")
                        .font(.caption.monospacedDigit())
                }
            }
        }
    }

    private func currentTurnText() -> String {
        switch gameMode {
        case .playerVsPlayer:
            return "Player \(gameBoard.currentPlayer.rawValue)'s turn"
        case .playerVsBot:
            return gameBoard.currentPlayer == .o ? "Computer's turn" : "Your turn"
        }
    }
}
