//
//  ContentView.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var showOnboarding = !OnboardingManager.hasSeenOnboarding
    
    var body: some View {
        Group {
            if showOnboarding {
                OnboardingView(isPresented: $showOnboarding)
                    .onChange(of: showOnboarding) { newValue in
                        if !newValue {
                            OnboardingManager.markOnboardingAsSeen()
                        }
                    }
            } else {
                MainHubView()
            }
        }
    }
}

#Preview {
    ContentView()
}
