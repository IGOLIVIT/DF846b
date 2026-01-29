//
//  Difficulty.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import Foundation

enum Difficulty: String, CaseIterable, Identifiable {
    case easy
    case medium
    case hard
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
    
    var levelCount: Int { 10 }
    
    var levelIds: [Int] {
        let startId: Int
        switch self {
        case .easy: startId = 1
        case .medium: startId = 11
        case .hard: startId = 21
        }
        return Array(startId..<(startId + levelCount))
    }
}
