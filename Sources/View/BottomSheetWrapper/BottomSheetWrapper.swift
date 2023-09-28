//
//  File.swift
//  
//
//  Created by Ayoub on 28/9/2023.
//

import SwiftUI

struct BottomSheetWrapper<Content: View>: View {
    
    @StateObject private var model = Model()
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
        return VStack {
            Spacer()
            FixedScroll(model, content: content)
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
        let model: Model
        let content: Content
        @ObservedConsumer private var offset: CGFloat
        @ObservedConsumer private var limitedSize: CGFloat

        init(_ model: Model, content: Content) {
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

