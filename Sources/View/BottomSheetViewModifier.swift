//
//  File.swift
//  
//
//  Created by Ayoub on 27/9/2023.
//

import Foundation
import SwiftUI



public struct BottomSheetViewModifier<ContentView: View>: ViewModifier {
    
    
    @ViewBuilder private var contentView: () -> ContentView
    @Binding private var show: Bool
    
    public init(content: @escaping () -> ContentView, show: Binding<Bool>) {
        self.contentView = content
        self._show = show
    }
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if show {
                Spacer()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .background(.black.opacity(0.5))
                    .animation(.default, value: self.show)
                    .onTapGesture {
                        self.show = false
                    }
                contentView()
                    .animation(.spring())
                    .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

