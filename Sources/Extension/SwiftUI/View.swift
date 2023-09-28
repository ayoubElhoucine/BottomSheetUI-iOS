//
//  File.swift
//  
//
//  Created by Ayoub on 6/9/2023.
//

import Foundation
import SwiftUI


extension View {
    public func asBottomSheetUI<ContentView: View>(show: Binding<Bool>, content: @escaping () -> ContentView) -> some View {
        self.modifier(BottomSheetViewModifier(content: content, show: show))
    }
}
