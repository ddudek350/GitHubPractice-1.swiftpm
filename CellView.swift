//
//  CellView.swift
//  GitHubPractice 1
//
//  Created by Damian O. Dudek on 5/5/25.
//

import SwiftUI

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
