import Foundation

enum GameMode: String, CaseIterable, Identifiable {
    case playerVsPlayer = "2 Players"
    case playerVsBot = "vs Computer"

    var id: Self { self }
    var displayName: String { self.rawValue }
}