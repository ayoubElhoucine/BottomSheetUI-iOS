//
//  File.swift
//  
//
//  Created by Ayoub on 6/9/2023.
//

import Foundation
import SwiftUI


struct Shimmer: View {
    let width: CGFloat
    let height: CGFloat
    let status: Bool
    
    @State private var state = true
    @State private var dragPoint = CGPoint(x: 0, y: 0)
            
    var body: some View {
        if status {
            Capsule()
                .fill(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .white.opacity(0.2), .white.opacity(0.3), .white.opacity(0.3), .white.opacity(0.2), .white.opacity(0.1)]), startPoint: .leading, endPoint: .trailing))
                .frame(maxWidth: 100, maxHeight: .infinity)
                .position(x: state ? (-100) : width + 100, y: dragPoint.y)
                .startPlaceholderAnimation(
                    $state,
                    revers: false,
                    duration: 1.2,
                    delay: 1.2
                )
                .onAppear {
                    self.dragPoint = CGPoint(x: height/2, y: height/2)
                }
        } else {
            EmptyView()
        }
    }
}
