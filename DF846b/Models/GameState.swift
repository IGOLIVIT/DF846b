//
//  GameState.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import Foundation
import CoreGraphics

enum GameState {
    case idle
    case playing
    case paused
    case completed
    case failed
}

struct CoreState {
    var position: CGPoint
    var rotation: Double = 0
    var glowIntensity: Double = 1.0
    var scale: CGFloat = 1.0
    
    mutating func reset() {
        rotation = 0
        glowIntensity = 1.0
        scale = 1.0
    }
}

struct GameProgress: Codable {
    var unlockedLevels: Set<Int> = [1] // Level 1 starts unlocked
    var completedLevels: Set<Int> = []
    var fragments: Int = 0
    var unlockedPatterns: Set<String> = []
    var unlockedCoreStates: Set<String> = []
    
    func isLevelUnlocked(_ levelId: Int) -> Bool {
        if levelId == 1 { return true }
        let previousLevel = levelId - 1
        return completedLevels.contains(previousLevel)
    }
    
    mutating func completeLevel(_ levelId: Int) {
        // Only award if level wasn't already completed
        let wasAlreadyCompleted = completedLevels.contains(levelId)
        completedLevels.insert(levelId)
        
        // Unlock next level
        let nextLevel = levelId + 1
        if nextLevel <= 30 {
            unlockedLevels.insert(nextLevel)
        }
        
        // Award fragments only if level wasn't already completed
        if !wasAlreadyCompleted {
            fragments += 10
        }
    }
}
