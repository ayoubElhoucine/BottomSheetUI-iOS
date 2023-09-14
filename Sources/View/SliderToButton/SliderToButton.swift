//
//  File.swift
//  
//
//  Created by Ayoub on 10/9/2023.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
public struct SliderToButton<Thumbnail: View>: View {
    
    @StateObject private var model = Model()
    
    let width: CGFloat
    let height: CGFloat
    let title: String
    let titleColor: Color
    let bgColor: Color
    let initialMode: Mode
    let didFinishSliding: () -> Void
    let didClick: () -> Void
    let thumbnail: () -> Thumbnail
    
    public init(width: CGFloat, height: CGFloat, title: String, titleColor: Color, bgColor: Color, initialMode: Mode, thumbnail: @escaping () -> Thumbnail, didFinishSliding: @escaping () -> Void, didClick: @escaping () -> Void) {
        self.width = width
        self.height = height
        self.title = title
        self.titleColor = titleColor
        self.bgColor = bgColor
        self.thumbnail = thumbnail
        self.initialMode = initialMode
        self.didFinishSliding = didFinishSliding
        self.didClick = didClick
    }
    
    public var body: some View {
        Capsule()
            .fill(.clear)
            .frame(width: model.calculatedWidth, height: height)
            .overlay {
                HStack(spacing: 0) {
                    Spacer(minLength: 0)
                    Capsule().fill(bgColor)
                        .frame(width:  model.bgWidth(height: height))
                }
                if model.mode == .slider {
                    if model.showTitle(width: width, height: height) {
                        Text(title).foregroundColor(titleColor).fontWeight(.semibold)
                    }
                    Shimmer(width: width, height: height, status: model.shimmerStatus)
                }
                thumbnail()
                    .frame(width: height, height: height)
                    .position(x: model.dragPoint.x, y: model.dragPoint.y)
                    .onTapGesture {
                        if model.mode == .button {
                            didClick()
                            self.model.updateMode(.slider, width: width, height: height)
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                model.updateDragPosition(value: value, width: width, height: height)
                            }
                            .onEnded { value in
                                model.endDraging(value: value, didFinishSliding: self.didFinishSliding, width: width, height: height)
                            }
                    )
            }
            .onAppear {
                self.model.setUp(width: width, height: height)
                self.model.updateMode(initialMode, width: width, height: height)
            }
    }
}
