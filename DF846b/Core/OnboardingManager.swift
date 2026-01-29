//
//  OnboardingManager.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import Foundation

class OnboardingManager {
    private static let hasSeenOnboardingKey = "AxiomDrop_HasSeenOnboarding"
    
    static var hasSeenOnboarding: Bool {
        UserDefaults.standard.bool(forKey: hasSeenOnboardingKey)
    }
    
    static func markOnboardingAsSeen() {
        UserDefaults.standard.set(true, forKey: hasSeenOnboardingKey)
    }
}
