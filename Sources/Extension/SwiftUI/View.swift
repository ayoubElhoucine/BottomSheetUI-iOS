//
//  File.swift
//  
//
//  Created by Ayoub on 6/9/2023.
//

import Foundation
import SwiftUI


extension View {
    
    @ViewBuilder
    public func startPlaceholderAnimation(
        _ option: Binding<Bool>,
        revers: Bool = true,
        duration: Double = 0.7,
        delay: Double = 0
    ) -> some View {
        let animation = Animation
            .easeInOut(duration: duration)
            .delay(delay)
            .repeatForever(autoreverses: revers)
        self
            .animation(animation, value: option.wrappedValue)
            .onAppear {
                DispatchQueue.main.async {
                    option.wrappedValue.toggle()
                }
            }
    }
    
}
