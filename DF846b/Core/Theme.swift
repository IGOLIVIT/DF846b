//
//  Theme.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import SwiftUI

struct Theme {
    // Colors from Assets.xcassets
    static let deepBlue = Color("DeepBlue")
    static let warmGold = Color("WarmGold")
    static let softCream = Color("SoftCream")
    
    // Gradients
    static let backgroundGradient = LinearGradient(
        colors: [deepBlue, deepBlue.opacity(0.8)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Spacing tokens
    static let spacingXS: CGFloat = 8
    static let spacingS: CGFloat = 12
    static let spacingM: CGFloat = 16
    static let spacingL: CGFloat = 24
    static let spacingXL: CGFloat = 32
    
    // Corner radius
    static let cornerRadius: CGFloat = 12
    static let cornerRadiusLarge: CGFloat = 20
    
    // Shadow
    static let shadow = Shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
    
    struct Shadow {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }
}
