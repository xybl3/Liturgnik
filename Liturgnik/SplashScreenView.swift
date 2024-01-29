//
//  SplashScreenView.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 27/01/2024.
//

import SwiftUI

struct SplashScreenView: View {
    @Binding var isShown: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var scale = 1.0
    
    var body: some View {
        ZStack {
            if colorScheme == .dark {
                Color.black.ignoresSafeArea()
            }
            else {
                Color.white.ignoresSafeArea()
            }
            Image("Cross")
                .scaleEffect(scale)
                .onAppear {
                    
                    for iter in 1...4 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400*iter)){
                            withAnimation(.easeInOut(duration: 0.5)){
                                scale = iter % 2 == 0 ? 3 : 1
                            }
                        }
                    }
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+3.5) {
                        withAnimation(.easeInOut(duration: 7)){
                            scale = 50000
                        }
                        withAnimation(.easeInOut(duration: 2)){
                            isShown = false
                        }
                    }
                }
        }
        .opacity(isShown ? 1 : 0)
    }
}

#Preview {
    SplashScreenView( isShown: .constant(true))
}
