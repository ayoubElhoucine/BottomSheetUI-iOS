//
//  File.swift
//  
//
//  Created by Ayoub on 5/9/2023.
//

import Foundation
import SwiftUI


@available(iOS 15.0, *)
public struct RatingSlider<Content: View>: View {
    
    @StateObject private var model = Model()
    
    let width: CGFloat
    let height: CGFloat
    let images: RatingImages
    let didRate: (Int) -> Void
    let content: () -> Content
    
    public init(width: CGFloat, height: CGFloat, images: RatingImages, content: @escaping () -> Content, didRate: @escaping (Int) -> Void) {
        self.width = width
        self.height = height
        self.images = images
        self.content = content
        self.didRate = didRate
    }
    
    public var body: some View {
        Capsule()
            .fill(.clear)
            .frame(width: width, height: height)
            .clipped()
            .overlay {
                ZStack {
                    content()
                    Shimmer(width: width, height: height, status: model.shimmerStatus)
                    Image(model.icon)
                        .resizable()
                        .frame(width: height - 5, height: height - 5)
                        .position(x: model.dragPoint.x, y: model.dragPoint.y)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                model.updateDragPosition(value: value, width: width, height: height)
                            }
                            .onEnded { value in
                                model.endDraging(value: value, didRate: didRate)
                            }
                    )
                }
            }
            .onAppear {
                self.model.setUp(width: width, height: height, images: images)
            }
    }
}
