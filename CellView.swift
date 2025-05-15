import SwiftUI

struct CellView: View {
    let content: Player?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(content?.rawValue ?? "")
                .font(.system(size: 24, weight: .bold))
                .frame(width: 44, height: 44)
                .background(Color.gray.opacity(content == nil ? 0.1 : 0.5))
                .foregroundColor(content?.color ?? .primary)
                .cornerRadius(8)
        }
        .disabled(content != nil)
    }
}
