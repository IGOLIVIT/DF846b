//
//  LevelData.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import Foundation
import CoreGraphics
import UIKit

struct LevelData {
    private static var cachedLevels: [Level]?
    
    static var allLevels: [Level] {
        if let cached = cachedLevels {
            return cached
        }
        
        let screenWidth = max(UIScreen.main.bounds.width, 375) // Fallback for previews
        let screenHeight = max(UIScreen.main.bounds.height, 667) // Fallback for previews
        
        var levels: [Level] = []
        
        // Easy levels (1-10) — nodes form a path: center and alternating sides so core can hit them
        for i in 1...10 {
            let levelId = i
            let nodeCount = 5 + i
            var nodes: [CGPoint] = []
            var nodeTypes: [Level.NodeType] = []
            let centerX = screenWidth / 2
            let margin: CGFloat = 80
            
            for j in 0..<nodeCount {
                // Alternating: center, left of center, center, right of center — so core can hit by tilting
                let x: CGFloat
                switch j % 3 {
                case 0: x = centerX
                case 1: x = max(margin, centerX - 80 - CGFloat(i * 5))
                default: x = min(screenWidth - margin, centerX + 80 + CGFloat(i * 5))
                }
                let y = CGFloat(180 + j * 100)
                nodes.append(CGPoint(x: x, y: y))
                nodeTypes.append(j % 3 == 0 ? .stabilizer : .neutral)
            }
            
            assert(nodes.count == nodeTypes.count, "Node positions and types must match")
            
            let targetZone = CGRect(
                x: screenWidth / 2 - 80,
                y: screenHeight - 150,
                width: 160,
                height: 80
            )
            
            levels.append(Level(
                id: levelId,
                difficulty: .easy,
                name: "Level \(levelId)",
                descentSpeed: 80 + Double(i * 5),
                pathWidth: 120,
                nodePositions: nodes,
                nodeTypes: nodeTypes,
                targetZones: [targetZone],
                destabilizers: [],
                description: "Navigate through the pattern"
            ))
        }
        
        // Medium levels (11-20)
        for i in 1...10 {
            let levelId = i + 10
            let nodeCount = 8 + i
            var nodes: [CGPoint] = []
            var nodeTypes: [Level.NodeType] = []
            
            let centerX = screenWidth / 2
            for j in 0..<nodeCount {
                // Zigzag path: center / left / right so player tilts to hit nodes
                let x: CGFloat
                switch j % 3 {
                case 0: x = centerX
                case 1: x = max(60, centerX - 100)
                default: x = min(screenWidth - 60, centerX + 100)
                }
                let y = CGFloat(160 + j * 85)
                nodes.append(CGPoint(x: x, y: y))
                
                if j % 4 == 0 {
                    nodeTypes.append(.stabilizer)
                } else if j % 3 == 0 {
                    nodeTypes.append(.patternTrigger)
                } else {
                    nodeTypes.append(.neutral)
                }
            }
            
            assert(nodes.count == nodeTypes.count, "Node positions and types must match")
            
            let targetZone = CGRect(
                x: screenWidth / 2 - 60,
                y: screenHeight - 150,
                width: 120,
                height: 60
            )
            
            // Destabilizer to the side so player can avoid by staying center
            let destabilizer = CGRect(
                x: screenWidth / 4 - 20,
                y: screenHeight - 220,
                width: 100,
                height: 50
            )
            
            levels.append(Level(
                id: levelId,
                difficulty: .medium,
                name: "Level \(levelId)",
                descentSpeed: 120 + Double(i * 8),
                pathWidth: 100,
                nodePositions: nodes,
                nodeTypes: nodeTypes,
                targetZones: [targetZone],
                destabilizers: [destabilizer],
                description: "Watch for obstacles"
            ))
        }
        
        // Hard levels (21-30)
        for i in 1...10 {
            let levelId = i + 20
            let nodeCount = 12 + i
            var nodes: [CGPoint] = []
            var nodeTypes: [Level.NodeType] = []
            
            let centerX = screenWidth / 2
            for j in 0..<nodeCount {
                // Narrow zigzag — harder to thread
                let x: CGFloat
                switch j % 3 {
                case 0: x = centerX
                case 1: x = max(55, centerX - 70)
                default: x = min(screenWidth - 55, centerX + 70)
                }
                let y = CGFloat(140 + j * 70)
                nodes.append(CGPoint(x: x, y: y))
                
                if j % 5 == 0 {
                    nodeTypes.append(.stabilizer)
                } else if j % 4 == 0 {
                    nodeTypes.append(.patternTrigger)
                } else if j % 3 == 0 {
                    nodeTypes.append(.speedBoost)
                } else {
                    nodeTypes.append(.neutral)
                }
            }
            
            assert(nodes.count == nodeTypes.count, "Node positions and types must match")
            
            let targetZone1 = CGRect(
                x: screenWidth / 2 - 50,
                y: screenHeight - 120,
                width: 100,
                height: 50
            )
            
            // Two obstacles — gap in the middle
            let destabilizer1 = CGRect(
                x: screenWidth / 4 - 30,
                y: screenHeight - 200,
                width: 90,
                height: 40
            )
            
            let destabilizer2 = CGRect(
                x: screenWidth * 3 / 4 - 60,
                y: screenHeight - 280,
                width: 90,
                height: 40
            )
            
            levels.append(Level(
                id: levelId,
                difficulty: .hard,
                name: "Level \(levelId)",
                descentSpeed: 150 + Double(i * 10),
                pathWidth: 80,
                nodePositions: nodes,
                nodeTypes: nodeTypes,
                targetZones: [targetZone1],
                destabilizers: [destabilizer1, destabilizer2],
                description: "Master the sequence"
            ))
        }
        
        cachedLevels = levels
        return levels
    }
    
    static func invalidateCache() {
        cachedLevels = nil
    }
}
