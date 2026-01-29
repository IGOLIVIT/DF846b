//
//  Level.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import Foundation
import CoreGraphics

struct Level: Identifiable {
    let id: Int
    let difficulty: Difficulty
    let name: String
    
    // Gameplay configuration
    let descentSpeed: Double // pixels per second
    let pathWidth: CGFloat // width of safe paths
    let nodePositions: [CGPoint] // positions of interactive nodes
    let nodeTypes: [NodeType] // type of each node
    let targetZones: [CGRect] // zones that must be reached
    let destabilizers: [CGRect] // zones to avoid
    
    // Level metadata
    let description: String
    
    enum NodeType: String {
        case stabilizer // helps control descent
        case patternTrigger // triggers pattern sequences
        case speedBoost // increases descent speed
        case slowZone // decreases descent speed
        case neutral // no effect
    }
}
