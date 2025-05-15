import SwiftUI

struct GameModePicker: View {
    @Binding var gameMode: GameMode
    let gameStarted: Bool

    var body: some View {
        Picker("Game Mode", selection: $gameMode) {
            ForEach(GameMode.allCases) { mode in
                Text(mode.displayName).tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .disabled(gameStarted)
    }
}

