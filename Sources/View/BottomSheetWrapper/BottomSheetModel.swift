//
//  File.swift
//  
//
//  Created by Ayoub on 28/9/2023.
//

import Foundation
import SwiftUI

let kSheetCornerRadius: CGFloat = 16
let kHandleHeight: CGFloat = 3

extension BottomSheetWrapper {
    class Model: ObservableObject {
        
        @Published var fullScreen: Bool = false
        @Published var dragOffset: CGFloat = 0

        @ObservedProducer var contentScrollOffset: CGFloat = 0
        @ObservedProducer var contentLimitedSize: CGFloat = 0
        @ObservedProducer var isScrollToBottom = true
        
        func closeSheet(_ popBack: @escaping () -> Void) {
            popBack()
        }
        
        func scrollToTop() {
            prevScrollOffset = 0
            contentScrollOffset = 0
            firstChange = true
            setNeedsChange()
        }
            
        init() {
            _contentScrollOffset.publisher
                .map {[weak self] value in
                    if let self = self {
                        return self.isScrollToBottom(value)
                    } else {
                        return true
                    }
                }.assign(to: &_isScrollToBottom.publisher)
        }
        
        private var closeAction: (()->Void)? = nil
        
        private var prevScrollOffset: CGFloat = .infinity
        var relativeContentScrollOffset: CGFloat {
            -(contentLimitedSize - contentHeight) / 2 - contentScrollOffset
        }
        
        func isScrollToBottom(_ value: CGFloat) -> Bool {
            !fullScreen || value >= contentHeight - contentLimitedSize
        }
        
        var topHeight: CGFloat = 0 {
            didSet {
                setNeedsChange()
            }
        }
        
        var contentHeight: CGFloat = 0 {
            didSet {
                setNeedsChange()
            }
        }
        
        fileprivate var bottomHeight: CGFloat = 0 {
            didSet {
                setNeedsChange()
            }
        }
        
        var totalHeight: CGFloat = 0 {
            willSet {
                if newValue != totalHeight {
                    setNeedsChange()
                }
            }
        }
      
        func handleScroll(offset: CGFloat, startY: CGFloat, final: Bool = false, popBack: @escaping () -> Void) {
            var finalDragOffset = offset
            if fullScreen && startY > topHeight {
                if !final, prevScrollOffset == .infinity  {
                    prevScrollOffset = contentScrollOffset
                }
                
                let min: CGFloat = 0
                let max = contentHeight - contentLimitedSize
                let result = prevScrollOffset - offset
                let offset = result < min ? min : (result > max ? max : result)

                if final {
                    if prevScrollOffset != 0, dragOffset == 0 {
                        finalDragOffset = 0   // reset drag offset if we start with already scrolled list
                    }
                    prevScrollOffset = .infinity
                    withAnimation(Animation.easeOut(duration: 0.3)) {
                        contentScrollOffset = offset
                    }
                } else {
                    if result < min {
                        finalDragOffset = min - result
                    } else {
                        finalDragOffset = 0
                    }
                    contentScrollOffset = offset
                }
            }
            
            if finalDragOffset != 0 {
                if final {
                    if finalDragOffset > (topHeight + contentLimitedSize + bottomHeight) / 2 {
                        if let action = closeAction {
                            action()
                        }
                        closeSheet(popBack)
                    } else {
                        // return to previous state
                        withAnimation {
                            dragOffset = 0
                        }
                    }
                } else {
                    if finalDragOffset >= 0 {
                        dragOffset = finalDragOffset
                    }
                }
            }
        }
        
        private var inUpdate = false
        @Published private var notifier: String = ""
        private func setNeedsChange() {
            if !inUpdate {
                inUpdate = true
                DispatchQueue.main.async {
                    self.postponedChange()
                }
            }
        }
        
        private var firstChange = true
        private func postponedChange() {
            inUpdate = false
            let newFullScreen = totalHeight < topHeight + contentHeight + bottomHeight + kSheetCornerRadius
            
            withAnimation(firstChange ? nil : .default) {
                // calculate limited size
                if newFullScreen {
                    contentLimitedSize = totalHeight - topHeight - bottomHeight
                    let max = contentHeight - contentLimitedSize
                    if contentScrollOffset > max {
                        contentScrollOffset = max
                    }
                } else {
                    contentScrollOffset = 0
                    contentLimitedSize = contentHeight
                }
                            
                // full screen
                if newFullScreen != fullScreen {
                    fullScreen = newFullScreen
                }
                
                isScrollToBottom = isScrollToBottom(contentScrollOffset)
            }
            
            firstChange = false
        }
    }
}
