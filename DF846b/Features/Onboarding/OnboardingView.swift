//
//  OnboardingView.swift
//  DF846b
//
//  Created by IGOR on 28/01/2026.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            text: "Control the descent",
            coreSize: 100
        ),
        OnboardingPage(
            text: "Patterns matter",
            coreSize: 120
        ),
        OnboardingPage(
            text: "Master the flow",
            coreSize: 100
        )
    ]
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)
            
            VStack {
                Spacer()
                
                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Theme.warmGold : Theme.warmGold.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, Theme.spacingL)
                
                // Continue button
                if currentPage < pages.count - 1 {
                    PrimaryButton(title: "Continue", action: {
                        withAnimation {
                            currentPage += 1
                        }
                    })
                    .padding(.horizontal, Theme.spacingL)
                    .padding(.bottom, Theme.spacingXL)
                } else {
                    PrimaryButton(title: "Begin", action: {
                        withAnimation {
                            isPresented = false
                        }
                    })
                    .padding(.horizontal, Theme.spacingL)
                    .padding(.bottom, Theme.spacingXL)
                }
            }
        }
    }
}

struct OnboardingPage {
    let text: String
    let coreSize: CGFloat
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var glowIntensity: Double = 1.0
    @State private var rotation: Double = 0
    
    var body: some View {
        VStack(spacing: Theme.spacingXL) {
            Spacer()
            
            TheCoreStatic(size: page.coreSize, glowIntensity: glowIntensity)
                .rotationEffect(.degrees(rotation))
            
            Text(page.text)
                .font(.system(size: 28, weight: .light))
                .foregroundColor(Theme.softCream)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.spacingXL)
            
            Spacer()
        }
        .onAppear {
            // Start glow animation
            withAnimation(
                Animation.easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
            ) {
                glowIntensity = 1.3
            }
            
            // Start rotation animation
            withAnimation(
                Animation.linear(duration: 10.0)
                    .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
        }
        .onDisappear {
            // Reset animations when view disappears
            glowIntensity = 1.0
            rotation = 0
        }
    }
}

#Preview("iPhone SE") {
    OnboardingView(isPresented: .constant(true))
        .previewDevice("iPhone SE (3rd generation)")
}

#Preview("iPhone 15 Pro Max") {
    OnboardingView(isPresented: .constant(true))
        .previewDevice("iPhone 15 Pro Max")
}

#Preview("iPad Air 11-inch") {
    OnboardingView(isPresented: .constant(true))
        .previewDevice("iPad Air (11-inch) (M3)")
}
