//
//  LevelCompletionView.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import SwiftUI

struct LevelCompletionView: View {
    let level: Level
    let score: Int
    @ObservedObject var progressService: ProgressService
    let onContinue: () -> Void
    
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: Theme.spacingXL) {
                Spacer()
                
                // Success animation
                TheCoreStatic(size: 120, glowIntensity: 1.5)
                    .scaleEffect(pulseScale)
                
                Text("Level Complete")
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(Theme.softCream)
                
                VStack(spacing: Theme.spacingM) {
                    StatRow(label: "Score", value: "\(score)")
                    StatRow(label: "Fragments Earned", value: "+10")
                    StatRow(label: "Total Fragments", value: "\(progressService.progress.fragments)")
                }
                .padding(Theme.spacingL)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: Theme.cornerRadius)
                        .fill(Theme.warmGold.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                .stroke(Theme.warmGold.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal, Theme.spacingL)
                
                Spacer()
                
                PrimaryButton(title: "Continue", action: onContinue)
                    .padding(.horizontal, Theme.spacingL)
                    .padding(.bottom, Theme.spacingXL)
            }
        }
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 1.0)
                    .repeatForever(autoreverses: true)
            ) {
                pulseScale = 1.15
            }
        }
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Theme.softCream.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.warmGold)
        }
    }
}

struct LevelFailureView: View {
    let onRetry: () -> Void
    let onQuit: () -> Void
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: Theme.spacingXL) {
                Spacer()
                
                TheCoreStatic(size: 100, glowIntensity: 0.5)
                    .opacity(0.7)
                
                Text("Try Again")
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(Theme.softCream)
                
                Text("Master the pattern")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Theme.softCream.opacity(0.7))
                
                Spacer()
                
                VStack(spacing: Theme.spacingM) {
                    PrimaryButton(title: "Retry", action: onRetry)
                    SecondaryButton(title: "Quit", action: onQuit)
                }
                .padding(.horizontal, Theme.spacingL)
                .padding(.bottom, Theme.spacingXL)
            }
        }
    }
}

#Preview {
    if let firstLevel = LevelData.allLevels.first {
        LevelCompletionView(
            level: firstLevel,
            score: 150,
            progressService: ProgressService(),
            onContinue: {}
        )
    } else {
        Text("No levels available")
    }
}
