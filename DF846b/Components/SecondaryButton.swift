//
//  SecondaryButton.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Theme.softCream)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    Theme.warmGold.opacity(0.2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.cornerRadius)
                        .stroke(Theme.warmGold, lineWidth: 2)
                )
                .cornerRadius(Theme.cornerRadius)
                .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        SecondaryButton(title: "Settings", action: {})
    }
    .padding()
    .background(Theme.backgroundGradient)
}
