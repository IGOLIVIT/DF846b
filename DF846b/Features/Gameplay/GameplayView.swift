//
//  GameplayView.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import SwiftUI

struct GameplayView: View {
    let level: Level
    @ObservedObject var progressService: ProgressService
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var gameService = GameService()
    @State private var showCompletion = false
    @State private var showFailure = false
    @State private var gameTimer: Timer?
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()
            
            // Use screen bounds so coordinates match LevelData and GameService exactly
            let gameSize = CGSize(
                width: max(UIScreen.main.bounds.width, 375),
                height: max(UIScreen.main.bounds.height, 667)
            )
            ZStack {
                // Target zones
                ForEach(Array(level.targetZones.enumerated()), id: \.offset) { _, zone in
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Theme.warmGold, lineWidth: 3)
                        .frame(width: zone.width, height: zone.height)
                        .position(x: zone.midX, y: zone.midY)
                }
                
                // Destabilizers
                ForEach(Array(level.destabilizers.enumerated()), id: \.offset) { _, zone in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Theme.warmGold.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Theme.warmGold.opacity(0.5), lineWidth: 2)
                        )
                        .frame(width: zone.width, height: zone.height)
                        .position(x: zone.midX, y: zone.midY)
                }
                
                // Interactive nodes
                ForEach(Array(zip(level.nodePositions.indices, level.nodePositions)), id: \.0) { index, position in
                    if index < level.nodeTypes.count {
                        NodeView(type: level.nodeTypes[index])
                            .position(position)
                    }
                }
                
                // The Core
                if gameService.gameState == .playing || gameService.gameState == .completed || gameService.gameState == .failed {
                    TheCore(
                        position: gameService.coreState.position,
                        rotation: gameService.coreState.rotation,
                        glowIntensity: gameService.coreState.glowIntensity,
                        scale: gameService.coreState.scale
                    )
                }
            }
            .frame(width: gameSize.width, height: gameSize.height)
            .ignoresSafeArea(edges: .all)
            
            // UI Overlay
            VStack {
                // Top bar
                HStack {
                    Button(action: {
                        gameService.reset()
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Theme.softCream)
                            .font(.system(size: 18, weight: .semibold))
                            .padding(Theme.spacingM)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: Theme.spacingXS) {
                        Text("Score: \(gameService.score)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Theme.softCream)
                        
                        Text("Stabilizers: \(gameService.stabilizersRemaining)")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Theme.softCream.opacity(0.7))
                    }
                }
                .padding(.horizontal, Theme.spacingM)
                .padding(.top, Theme.spacingM)
                
                Spacer()
                
                // Control buttons
                if gameService.gameState == .playing {
                    HStack(spacing: Theme.spacingL) {
                        Button(action: {
                            gameService.applyTilt(.left)
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(Theme.deepBlue)
                                .font(.system(size: 24, weight: .bold))
                                .frame(width: 60, height: 60)
                                .background(Theme.warmGold)
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            gameService.activateStabilizer()
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: "shield.fill")
                                    .foregroundColor(Theme.deepBlue)
                                    .font(.system(size: 20, weight: .bold))
                                Text("\(gameService.stabilizersRemaining)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Theme.deepBlue)
                            }
                            .frame(width: 60, height: 60)
                            .background(
                                gameService.stabilizersRemaining > 0
                                    ? Theme.warmGold
                                    : Theme.warmGold.opacity(0.3)
                            )
                            .clipShape(Circle())
                        }
                        .disabled(gameService.stabilizersRemaining == 0)
                        
                        Button(action: {
                            gameService.applyTilt(.right)
                        }) {
                            Image(systemName: "arrow.right")
                                .foregroundColor(Theme.deepBlue)
                                .font(.system(size: 24, weight: .bold))
                                .frame(width: 60, height: 60)
                                .background(Theme.warmGold)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.bottom, Theme.spacingXL)
                }
            }
        }
        .onAppear {
            // Ensure level has valid data
            guard level.nodePositions.count == level.nodeTypes.count else {
                dismiss()
                return
            }
            gameService.startLevel(level)
            startGameLoop()
        }
        .onDisappear {
            gameTimer?.invalidate()
            gameTimer = nil
            gameService.reset()
        }
        .onChange(of: gameService.gameState) { newState in
            if newState == .completed {
                gameTimer?.invalidate()
                gameTimer = nil
                guard !showCompletion else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    progressService.completeLevel(level.id)
                    showCompletion = true
                }
            } else if newState == .failed {
                gameTimer?.invalidate()
                gameTimer = nil
                guard !showFailure else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showFailure = true
                }
            }
        }
        .sheet(isPresented: $showCompletion) {
            LevelCompletionView(
                level: level,
                score: gameService.score,
                progressService: progressService,
                onContinue: {
                    dismiss()
                }
            )
        }
        .sheet(isPresented: $showFailure) {
            LevelFailureView(
                onRetry: {
                    gameService.startLevel(level)
                    showFailure = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        startGameLoop()
                    }
                },
                onQuit: {
                    gameService.reset()
                    dismiss()
                }
            )
        }
    }
    
    private func startGameLoop() {
        guard gameTimer == nil else { return }
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { timer in
            guard gameService.gameState == .playing else {
                timer.invalidate()
                return
            }
            let currentTime = Date()
            let deltaTime = gameService.tick(at: currentTime)
            DispatchQueue.main.async {
                gameService.updateCorePosition(deltaTime: deltaTime)
            }
        }
        
        if let timer = gameTimer {
            RunLoop.current.add(timer, forMode: .common)
        }
    }
}

struct NodeView: View {
    let type: Level.NodeType
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    type == .stabilizer
                        ? Theme.warmGold.opacity(0.6)
                        : Theme.warmGold.opacity(0.3)
                )
                .frame(width: 20, height: 20)
            
            Circle()
                .stroke(Theme.warmGold, lineWidth: 2)
                .frame(width: 24, height: 24)
        }
    }
}

#Preview("iPhone SE") {
    if let firstLevel = LevelData.allLevels.first {
        GameplayView(
            level: firstLevel,
            progressService: ProgressService()
        )
        .previewDevice("iPhone SE (3rd generation)")
    } else {
        Text("No levels available")
            .previewDevice("iPhone SE (3rd generation)")
    }
}

#Preview("iPhone 15 Pro Max") {
    if let firstLevel = LevelData.allLevels.first {
        GameplayView(
            level: firstLevel,
            progressService: ProgressService()
        )
        .previewDevice("iPhone 15 Pro Max")
    } else {
        Text("No levels available")
            .previewDevice("iPhone 15 Pro Max")
    }
}
