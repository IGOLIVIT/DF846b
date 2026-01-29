//
//  TheCore.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import SwiftUI

struct TheCore: View {
    let position: CGPoint
    let rotation: Double
    let glowIntensity: Double
    let scale: CGFloat
    
    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Theme.warmGold.opacity(0.6 * glowIntensity),
                            Theme.warmGold.opacity(0.2 * glowIntensity),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 15,
                        endRadius: 40
                    )
                )
                .frame(width: 80, height: 80)
                .blur(radius: 8)
            
            // Main orb
            ZStack {
                // Inner light
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Theme.softCream.opacity(0.9),
                                Theme.warmGold.opacity(0.7),
                                Theme.warmGold.opacity(0.3)
                            ],
                            center: .center,
                            startRadius: 5,
                            endRadius: 20
                        )
                    )
                    .frame(width: 40, height: 40)
                
                // Geometric pattern overlay
                Circle()
                    .stroke(Theme.warmGold.opacity(0.5), lineWidth: 2)
                    .frame(width: 35, height: 35)
                
                Circle()
                    .stroke(Theme.warmGold.opacity(0.3), lineWidth: 1)
                    .frame(width: 25, height: 25)
            }
            .frame(width: 40, height: 40)
        }
        .scaleEffect(scale)
        .rotationEffect(.degrees(rotation))
        .position(position)
    }
}

struct TheCoreStatic: View {
    let size: CGFloat
    let glowIntensity: Double
    
    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Theme.warmGold.opacity(0.5 * glowIntensity),
                            Theme.warmGold.opacity(0.1 * glowIntensity),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: size * 0.2,
                        endRadius: size * 0.6
                    )
                )
                .frame(width: size * 1.5, height: size * 1.5)
                .blur(radius: size * 0.15)
            
            // Main orb
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Theme.softCream.opacity(0.9),
                                Theme.warmGold.opacity(0.7),
                                Theme.warmGold.opacity(0.3)
                            ],
                            center: .center,
                            startRadius: size * 0.1,
                            endRadius: size * 0.4
                        )
                    )
                    .frame(width: size, height: size)
                
                Circle()
                    .stroke(Theme.warmGold.opacity(0.5), lineWidth: size * 0.05)
                    .frame(width: size * 0.85, height: size * 0.85)
                
                Circle()
                    .stroke(Theme.warmGold.opacity(0.3), lineWidth: size * 0.025)
                    .frame(width: size * 0.6, height: size * 0.6)
            }
        }
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient
            .ignoresSafeArea()
        
        VStack(spacing: 40) {
            TheCoreStatic(size: 60, glowIntensity: 1.0)
            TheCore(
                position: CGPoint(x: 200, y: 300),
                rotation: 45,
                glowIntensity: 1.2,
                scale: 1.0
            )
        }
    }
}
