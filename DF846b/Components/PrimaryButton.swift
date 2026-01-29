//
//  PrimaryButton.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.deepBlue)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    isEnabled ? Theme.warmGold : Theme.warmGold.opacity(0.5)
                )
                .cornerRadius(Theme.cornerRadius)
                .shadow(
                    color: Theme.shadow.color,
                    radius: Theme.shadow.radius,
                    x: Theme.shadow.x,
                    y: Theme.shadow.y
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .disabled(!isEnabled)
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if isEnabled {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(title: "Start", action: {})
        PrimaryButton(title: "Disabled", action: {}, isEnabled: false)
    }
    .padding()
    .background(Theme.backgroundGradient)
}
