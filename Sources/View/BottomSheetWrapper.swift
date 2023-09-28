//
//  File.swift
//  
//
//  Created by Ayoub on 28/9/2023.
//

import SwiftUI

fileprivate let kSheetCornerRadius: CGFloat = 16
fileprivate let kHandleHeight: CGFloat = 3

class BottomSheetModel: ObservableObject {
    
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
        
    fileprivate init() {
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
    fileprivate var relativeContentScrollOffset: CGFloat {
        -(contentLimitedSize - contentHeight) / 2 - contentScrollOffset
    }
    
    fileprivate func isScrollToBottom(_ value: CGFloat) -> Bool {
        !fullScreen || value >= contentHeight - contentLimitedSize
    }
    
    fileprivate var topHeight: CGFloat = 0 {
        didSet {
            setNeedsChange()
        }
    }
    
    fileprivate var contentHeight: CGFloat = 0 {
        didSet {
            setNeedsChange()
        }
    }
    
    fileprivate var bottomHeight: CGFloat = 0 {
        didSet {
            setNeedsChange()
        }
    }
    
    fileprivate var totalHeight: CGFloat = 0 {
        willSet {
            if newValue != totalHeight {
                setNeedsChange()
            }
        }
    }
  
    fileprivate func handleScroll(offset: CGFloat, startY: CGFloat, final: Bool = false, popBack: @escaping () -> Void) {
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

struct BottomSheetWrapper<Content: View>: View {
    
    @StateObject private var model = BottomSheetModel()
    private let content: Content
    
    private let popBack: () -> Void
    

    init(@ViewBuilder contentFactory: @escaping () -> Content, popBack: @escaping () -> Void) {
        content = contentFactory()
        self.popBack = popBack
    }

    var body: some View {
        GeometryReader { proxy in
            mainBody(proxy, popBack: popBack)
        }
    }
    
    func mainBody(_ proxy: GeometryProxy, popBack: @escaping () -> Void) -> some View {
        model.totalHeight = proxy.size.height
        return ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Spacer()
                FixedScroll(model, content: content)
            }
            .offset(x: 0, y: model.dragOffset)
            .highPriorityGesture(
                DragGesture()
                    .onChanged { gesture in
                        self.model.handleScroll(offset: gesture.translation.height, startY: gesture.startLocation.y, popBack: popBack)
                    }.onEnded { gesture in
                        self.model.handleScroll(offset: gesture.predictedEndTranslation.height, startY: gesture.startLocation.y, final: true, popBack: popBack)
                    }
            )
        }
    }
 
    private class FloatStorage: ObservableObject {
        var value: CGFloat = 0
    }

    private struct HeightGetter: View {
        @StateObject private var storage = FloatStorage()
        private let callback: (CGFloat) -> Void

        init(callback: @escaping (CGFloat) -> Void) {
            self.callback = callback
        }

        var body: some View {
            GeometryReader { proxy in
                handleProxy(proxy: proxy)
            }
        }

        private func handleProxy(proxy: GeometryProxy) -> EmptyView? {
            let height = proxy.size.height
            if height != storage.value {
                storage.value = height
                callback(height)
            }
            return nil
        }
    }

    private struct FixedScroll: View {
        let model: BottomSheetModel
        let content: Content
        @ObservedConsumer private var offset: CGFloat
        @ObservedConsumer private var limitedSize: CGFloat

        init(_ model: BottomSheetModel, content: Content) {
            self.model = model
            self.content = content
            _offset = model.$contentScrollOffset
            _limitedSize = model.$contentLimitedSize
        }

        var body: some View {
            Group {
                content
                    .environmentObject(model)
                    .background(HeightGetter { model.contentHeight = $0 })
                    .offset(x: 0, y: model.relativeContentScrollOffset)
            }.frame(maxHeight: limitedSize)
                .clipped()
                .contentShape(Rectangle())
        }
    }
}

