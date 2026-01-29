//
//  GameService.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import Foundation
import CoreGraphics
import UIKit
import Combine

class GameService: ObservableObject {
    @Published var currentLevel: Level?
    @Published var gameState: GameState = .idle
    @Published var coreState = CoreState(position: .zero)
    @Published var score: Int = 0
    @Published var stabilizersRemaining: Int = 3
    
    private var levels: [Level] = []
    private var hitNodes: Set<Int> = []
    private var stabilizerActiveUntil: Date?
    private(set) var lastUpdateTime: Date = Date()
    private var previousPosition: CGPoint = .zero
    
    init() {
        loadLevels()
    }
    
    func loadLevels() {
        levels = LevelData.allLevels
    }
    
    func startLevel(_ level: Level) {
        currentLevel = level
        gameState = .playing
        score = 0
        stabilizersRemaining = 3
        hitNodes = []
        stabilizerActiveUntil = nil
        lastUpdateTime = Date()
        let screenWidth = max(UIScreen.main.bounds.width, 375)
        let start = CGPoint(x: screenWidth / 2, y: 100)
        coreState = CoreState(position: start)
        previousPosition = start
        coreState.reset()
    }
    
    func applyTilt(_ direction: TiltDirection) {
        guard gameState == .playing else { return }
        
        let screenWidth = max(UIScreen.main.bounds.width, 375)
        let tiltAmount: CGFloat = 20
        let newX = coreState.position.x + (direction == .left ? -tiltAmount : tiltAmount)
        let clampedX = max(50, min(screenWidth - 50, newX))
        coreState.position.x = clampedX
    }
    
    func activateStabilizer() {
        guard stabilizersRemaining > 0 else { return }
        stabilizersRemaining -= 1
        // Stabilizer effect: slow descent for 2 seconds
        stabilizerActiveUntil = Date().addingTimeInterval(2.0)
    }
    
    func checkCollisions() {
        guard let level = currentLevel, gameState == .playing else { return }
        
        // Check destabilizers first — hitting obstacle = fail
        for destabilizer in level.destabilizers {
            if destabilizer.contains(coreState.position) {
                handleDestabilizerHit()
                return
            }
        }
        
        // Then target zones — reaching goal = win
        for zone in level.targetZones {
            if zone.contains(coreState.position) {
                handleTargetZoneHit()
                return
            }
        }
        
        // Check nodes (only once per node)
        // Core visual ~40pt, node ~12pt → use 55pt so overlap is reliable
        let nodeCollisionRadius: CGFloat = 55
        guard level.nodePositions.count == level.nodeTypes.count else { return }
        
        let prev = previousPosition
        let curr = coreState.position
        
        for (index, nodePos) in level.nodePositions.enumerated() {
            guard !hitNodes.contains(index), index < level.nodeTypes.count else { continue }
            let dx = curr.x - nodePos.x
            let dy = curr.y - nodePos.y
            let distance = sqrt(dx * dx + dy * dy)
            if distance < nodeCollisionRadius {
                hitNodes.insert(index)
                handleNodeHit(level.nodeTypes[index], at: nodePos)
                continue
            }
            let prevDx = prev.x - nodePos.x
            let prevDy = prev.y - nodePos.y
            if sqrt(prevDx * prevDx + prevDy * prevDy) < nodeCollisionRadius {
                hitNodes.insert(index)
                handleNodeHit(level.nodeTypes[index], at: nodePos)
                continue
            }
            // Segment prev→curr vs circle: closest point on segment to node
            let segDx = curr.x - prev.x
            let segDy = curr.y - prev.y
            let segLenSq = segDx * segDx + segDy * segDy
            if segLenSq > 0.0001 {
                let t = ((nodePos.x - prev.x) * segDx + (nodePos.y - prev.y) * segDy) / segLenSq
                let tClamp = max(0, min(1, t))
                let closestX = prev.x + tClamp * segDx
                let closestY = prev.y + tClamp * segDy
                let closestDx = nodePos.x - closestX
                let closestDy = nodePos.y - closestY
                if sqrt(closestDx * closestDx + closestDy * closestDy) < nodeCollisionRadius {
                    hitNodes.insert(index)
                    handleNodeHit(level.nodeTypes[index], at: nodePos)
                }
            }
        }
    }
    
    private func handleTargetZoneHit() {
        gameState = .completed
        coreState.glowIntensity = 1.5
        coreState.scale = 1.2
    }
    
    private func handleDestabilizerHit() {
        gameState = .failed
        coreState.glowIntensity = 0.3
    }
    
    private func handleNodeHit(_ type: Level.NodeType, at position: CGPoint) {
        guard gameState == .playing else { return }
        
        switch type {
        case .stabilizer:
            coreState.glowIntensity = 1.3
            score += 10
        case .patternTrigger:
            score += 20
            coreState.glowIntensity = 1.4
        case .speedBoost:
            score += 5
        case .slowZone:
            score += 15
        case .neutral:
            break
        }
        
        // Visual feedback
        coreState.scale = 1.15
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self, self.gameState == .playing else { return }
            self.coreState.scale = 1.0
        }
    }
    
    /// Returns delta time and updates internal timestamp. Call from game loop.
    func tick(at currentTime: Date = Date()) -> TimeInterval {
        let delta = currentTime.timeIntervalSince(lastUpdateTime)
        lastUpdateTime = currentTime
        return delta
    }
    
    func updateCorePosition(deltaTime: TimeInterval) {
        guard let level = currentLevel, gameState == .playing else { return }
        
        // Apply stabilizer effect if active
        var speedMultiplier: Double = 1.0
        if let stabilizerUntil = stabilizerActiveUntil, Date() < stabilizerUntil {
            speedMultiplier = 0.3 // Slow descent significantly
        } else {
            stabilizerActiveUntil = nil
        }
        
        previousPosition = coreState.position
        let descent = level.descentSpeed * deltaTime * speedMultiplier
        coreState.position.y += descent
        coreState.rotation += 0.05
        
        // Ensure position stays within reasonable bounds
        let screenHeight = max(UIScreen.main.bounds.height, 667)
        let screenWidth = max(UIScreen.main.bounds.width, 375)
        
        // Check if out of bounds vertically
        if coreState.position.y > screenHeight + 100 {
            gameState = .failed
        }
        
        // Clamp horizontal position to prevent going off-screen
        coreState.position.x = max(50, min(screenWidth - 50, coreState.position.x))
        
        // Prevent negative Y position
        if coreState.position.y < 0 {
            coreState.position.y = 0
        }
        
        checkCollisions()
    }
    
    func reset() {
        gameState = .idle
        currentLevel = nil
        coreState.reset()
        score = 0
        stabilizersRemaining = 3
        hitNodes = []
        stabilizerActiveUntil = nil
    }
}

enum TiltDirection {
    case left
    case right
}
