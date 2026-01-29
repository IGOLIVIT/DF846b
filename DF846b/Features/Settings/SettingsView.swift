//
//  SettingsView.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var progressService: ProgressService
    @State private var showResetConfirmation = false
    
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
                    
                    Text("Stats")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Theme.softCream)
                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal, Theme.spacingM)
                .padding(.top, Theme.spacingM)
                
                ScrollView {
                    VStack(spacing: Theme.spacingL) {
                        // Stats section
                        VStack(alignment: .leading, spacing: Theme.spacingM) {
                            Text("Progress")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Theme.softCream)
                            
                            StatCard(
                                title: "Levels Completed",
                                value: "\(progressService.progress.completedLevels.count) / 30"
                            )
                            
                            StatCard(
                                title: "Fragments Collected",
                                value: "\(progressService.progress.fragments)"
                            )
                            
                            StatCard(
                                title: "Patterns Unlocked",
                                value: "\(progressService.progress.unlockedPatterns.count)"
                            )
                            
                            StatCard(
                                title: "Core States Unlocked",
                                value: "\(progressService.progress.unlockedCoreStates.count)"
                            )
                        }
                        .padding(Theme.spacingL)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                .fill(Theme.warmGold.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                        .stroke(Theme.warmGold.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, Theme.spacingL)
                        .padding(.top, Theme.spacingL)
                        
                        // Reset section
                        VStack(alignment: .leading, spacing: Theme.spacingM) {
                            Text("Reset Progress")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Theme.softCream)
                            
                            Text("This will permanently delete all your progress, including completed levels and collected fragments.")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Theme.softCream.opacity(0.7))
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Button(action: {
                                showResetConfirmation = true
                            }) {
                                Text("Reset All Progress")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                            .fill(Color.red.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                                    .stroke(Color.red.opacity(0.5), lineWidth: 1)
                                            )
                                    )
                            }
                        }
                        .padding(Theme.spacingL)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                .fill(Theme.warmGold.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                        .stroke(Theme.warmGold.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, Theme.spacingL)
                        
                        Spacer()
                            .frame(height: 40)
                    }
                }
            }
        }
        .alert("Reset Progress", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                progressService.resetProgress()
            }
        } message: {
            Text("Are you sure you want to reset all progress? This action cannot be undone.")
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Theme.softCream.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.warmGold)
        }
        .padding(.vertical, Theme.spacingXS)
    }
}

#Preview {
    SettingsView(progressService: ProgressService())
}
