//
//  DifficultySelectionView.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import SwiftUI

struct DifficultySelectionView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var progressService: ProgressService
    let initialDifficulty: Difficulty
    @State private var selectedDifficulty: Difficulty
    @State private var selectedLevel: Level?
    
    init(progressService: ProgressService, initialDifficulty: Difficulty = .easy) {
        self.progressService = progressService
        self.initialDifficulty = initialDifficulty
        self._selectedDifficulty = State(initialValue: initialDifficulty)
    }
    
    var levelsForDifficulty: [Level] {
        LevelData.allLevels.filter { $0.difficulty == selectedDifficulty }
    }
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Theme.softCream)
                            .font(.system(size: 18, weight: .semibold))
                            .padding(Theme.spacingM)
                    }
                    
                    Spacer()
                    
                    Text(selectedDifficulty.displayName)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Theme.softCream)
                    
                    Spacer()
                    
                    // Spacer for balance
                    Color.clear
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal, Theme.spacingM)
                .padding(.top, Theme.spacingM)
                
                // Difficulty selector
                HStack(spacing: Theme.spacingS) {
                    ForEach(Difficulty.allCases) { difficulty in
                        Button(action: {
                            withAnimation {
                                selectedDifficulty = difficulty
                            }
                        }) {
                            Text(difficulty.displayName)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(
                                    selectedDifficulty == difficulty ? Theme.deepBlue : Theme.softCream
                                )
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(
                                    selectedDifficulty == difficulty ? Theme.warmGold : Theme.warmGold.opacity(0.2)
                                )
                                .cornerRadius(Theme.cornerRadius)
                        }
                    }
                }
                .padding(.horizontal, Theme.spacingL)
                .padding(.top, Theme.spacingL)
                
                // Level grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: Theme.spacingM),
                        GridItem(.flexible(), spacing: Theme.spacingM)
                    ], spacing: Theme.spacingM) {
                        ForEach(levelsForDifficulty) { level in
                            LevelCard(
                                level: level,
                                isUnlocked: progressService.isLevelUnlocked(level.id),
                                isCompleted: progressService.progress.completedLevels.contains(level.id)
                            ) {
                                selectedLevel = level
                            }
                        }
                    }
                    .padding(Theme.spacingL)
                }
            }
        }
        .fullScreenCover(item: $selectedLevel) { level in
            GameplayView(
                level: level,
                progressService: progressService
            )
        }
    }
}

struct LevelCard: View {
    let level: Level
    let isUnlocked: Bool
    let isCompleted: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            if isUnlocked {
                action()
            }
        }) {
            VStack(spacing: Theme.spacingS) {
                ZStack {
                    Circle()
                        .fill(
                            isUnlocked
                                ? (isCompleted ? Theme.warmGold.opacity(0.3) : Theme.warmGold.opacity(0.15))
                                : Theme.warmGold.opacity(0.05)
                        )
                        .frame(width: 60, height: 60)
                    
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .foregroundColor(Theme.warmGold)
                            .font(.system(size: 24, weight: .bold))
                    } else if !isUnlocked {
                        Image(systemName: "lock.fill")
                            .foregroundColor(Theme.softCream.opacity(0.3))
                            .font(.system(size: 20, weight: .medium))
                    } else {
                        Text("\(level.id)")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Theme.warmGold)
                    }
                }
                
                Text(level.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(
                        isUnlocked ? Theme.softCream : Theme.softCream.opacity(0.4)
                    )
            }
            .frame(maxWidth: .infinity)
            .padding(Theme.spacingM)
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .fill(
                        isUnlocked
                            ? Theme.warmGold.opacity(0.1)
                            : Theme.warmGold.opacity(0.05)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.cornerRadius)
                            .stroke(
                                isUnlocked
                                    ? Theme.warmGold.opacity(0.4)
                                    : Theme.warmGold.opacity(0.1),
                                lineWidth: 1
                            )
                    )
            )
        }
        .disabled(!isUnlocked)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DifficultySelectionView(progressService: ProgressService(), initialDifficulty: .easy)
}
