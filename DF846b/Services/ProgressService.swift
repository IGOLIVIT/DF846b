//
//  ProgressService.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import Foundation
import Combine

class ProgressService: ObservableObject {
    @Published var progress: GameProgress
    
    private let progressKey = "AxiomDrop_Progress"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: progressKey),
           let decoded = try? JSONDecoder().decode(GameProgress.self, from: data) {
            self.progress = decoded
        } else {
            self.progress = GameProgress()
        }
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(encoded, forKey: progressKey)
        }
    }
    
    func completeLevel(_ levelId: Int) {
        progress.completeLevel(levelId)
        
        let completedCount = progress.completedLevels.count
        
        // Unlock patterns at milestones (check if not already unlocked)
        if completedCount >= 5 && !progress.unlockedPatterns.contains("Pattern_Spiral") {
            unlockPattern("Pattern_Spiral")
        }
        if completedCount >= 10 && !progress.unlockedPatterns.contains("Pattern_Orbit") {
            unlockPattern("Pattern_Orbit")
        }
        if completedCount >= 20 && !progress.unlockedPatterns.contains("Pattern_Flux") {
            unlockPattern("Pattern_Flux")
        }
        if completedCount >= 30 && !progress.unlockedPatterns.contains("Pattern_Master") {
            unlockPattern("Pattern_Master")
        }
        
        // Unlock core states at milestones (check if not already unlocked)
        if completedCount >= 15 && !progress.unlockedCoreStates.contains("State_Brilliant") {
            unlockCoreState("State_Brilliant")
        }
        if completedCount >= 25 && !progress.unlockedCoreStates.contains("State_Radiant") {
            unlockCoreState("State_Radiant")
        }
        
        save()
    }
    
    func resetProgress() {
        progress = GameProgress()
        save()
    }
    
    func isLevelUnlocked(_ levelId: Int) -> Bool {
        progress.isLevelUnlocked(levelId)
    }
    
    func addFragments(_ amount: Int) {
        progress.fragments += amount
        save()
    }
    
    func unlockPattern(_ patternName: String) {
        progress.unlockedPatterns.insert(patternName)
        save()
    }
    
    func unlockCoreState(_ stateName: String) {
        progress.unlockedCoreStates.insert(stateName)
        save()
    }
}
