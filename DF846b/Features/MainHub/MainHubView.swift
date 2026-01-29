//
//  MainHubView.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import SwiftUI

struct MainHubView: View {
    @StateObject private var progressService = ProgressService()
    @State private var showDifficultySelection = false
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()
            
            // Background Core
            VStack {
                Spacer()
                TheCoreStatic(size: 150, glowIntensity: 0.6)
                    .opacity(0.3)
                    .padding(.bottom, 100)
            }
            
            ScrollView {
                VStack(spacing: Theme.spacingXL) {
                    Spacer()
                        .frame(height: 60)
                    
                    // Title area
                    VStack(spacing: Theme.spacingM) {
                        TheCoreStatic(size: 80, glowIntensity: 1.0)
                        
                        Text("Choose Your Path")
                            .font(.system(size: 32, weight: .light))
                            .foregroundColor(Theme.softCream)
                    }
                    .padding(.top, Theme.spacingXL)
                    
                    // Progress summary
                    VStack(spacing: Theme.spacingS) {
                        Text("Progress")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Theme.softCream.opacity(0.8))
                        
                        Text("\(progressService.progress.completedLevels.count) / 30")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Theme.warmGold)
                        
                        Text("Fragments: \(progressService.progress.fragments)")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Theme.softCream.opacity(0.7))
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
                    
                    // Difficulty buttons
                    VStack(spacing: Theme.spacingM) {
                        ForEach(Difficulty.allCases) { difficulty in
                            DifficultyCard(
                                difficulty: difficulty,
                                completedCount: progressService.progress.completedLevels.filter { levelId in
                                    LevelData.allLevels.first(where: { $0.id == levelId })?.difficulty == difficulty
                                }.count,
                                totalCount: difficulty.levelCount
                            ) {
                                selectedDifficulty = difficulty
                                showDifficultySelection = true
                            }
                        }
                    }
                    .padding(.horizontal, Theme.spacingL)
                    
                    // Settings button
                    SecondaryButton(title: "Settings", action: {
                        showSettings = true
                    })
                    .padding(.horizontal, Theme.spacingL)
                    .padding(.top, Theme.spacingM)
                    
                    Spacer()
                        .frame(height: 40)
                }
            }
        }
        .sheet(isPresented: $showDifficultySelection) {
            DifficultySelectionView(
                progressService: progressService,
                initialDifficulty: selectedDifficulty
            )
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(progressService: progressService)
        }
    }
}

struct DifficultyCard: View {
    let difficulty: Difficulty
    let completedCount: Int
    let totalCount: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.spacingXS) {
                    Text(difficulty.displayName)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(Theme.softCream)
                    
                    Text("\(completedCount) / \(totalCount) completed")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Theme.softCream.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.warmGold)
                    .font(.system(size: 16, weight: .semibold))
            }
            .padding(Theme.spacingL)
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .fill(Theme.warmGold.opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.cornerRadius)
                            .stroke(Theme.warmGold.opacity(0.4), lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview("iPhone SE") {
    MainHubView()
        .previewDevice("iPhone SE (3rd generation)")
}

#Preview("iPhone 15 Pro Max") {
    MainHubView()
        .previewDevice("iPhone 15 Pro Max")
}

#Preview("iPad Air 11-inch") {
    MainHubView()
        .previewDevice("iPad Air (11-inch) (M3)")
}
