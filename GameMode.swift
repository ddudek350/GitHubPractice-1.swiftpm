import SwiftUI

enum GameMode: String, CaseIterable, Identifiable {
    case playerVsPlayer = "2 Players"
    case playerVsBot = "vs Computer"
    
    var id: String { rawValue }
}