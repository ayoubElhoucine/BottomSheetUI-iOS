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
                .zIndex(0)
            if show {
                Spacer()
                    .zIndex(1)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .background(.black.opacity(0.4))
                    .animation(.default, value: self.show)
                    .onTapGesture {
                        withAnimation {
                            self.show = false
                        }
                    }
                BottomSheetWrapper {
                    contentView()
                } popBack: {
                    withAnimation {
                        self.show = false
                    }
                }
                .zIndex(2)
                .animation(.easeIn)
                .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

