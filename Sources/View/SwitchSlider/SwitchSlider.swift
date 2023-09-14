//
//  File.swift
//  
//
//  Created by Ayoub on 7/9/2023.
//

import Foundation
import SwiftUI


@available(iOS 15.0, *)
public struct SwitchSlider<Thumbnail: View>: View {
    
    @StateObject private var model = Model()
    
    let width: CGFloat
    let height: CGFloat
    let title: String
    let titleColor: Color
    let colorOn: Color
    let colorOff: Color
    let didComplete: (Bool) -> Void
    let thumbnail: () -> Thumbnail
    
    public init(width: CGFloat, height: CGFloat, title: String, titleColor: Color, colorOn: Color, colorOff: Color, thumbnail: @escaping () -> Thumbnail, didComplete: @escaping (Bool) -> Void) {
        self.width = width
        self.height = height
        self.title = title
        self.titleColor = titleColor
        self.colorOn = colorOn
        self.colorOff = colorOff
        self.thumbnail = thumbnail
        self.didComplete = didComplete
    }
    
    public var body: some View {
        Capsule()
            .fill(.clear)
            .frame(width: width, height: height)
            .overlay {
                Capsule().fill(colorOff)
                HStack(spacing: 0) {
                    Capsule().fill(colorOn)
                        .frame(width: model.dragPoint.x + height/2)
                    Spacer(minLength: 0)
                }
                Text(title).foregroundColor(titleColor).fontWeight(.semibold)
                Shimmer(width: width, height: height, status: model.shimmerStatus)
                thumbnail()
                    .frame(width: height, height: height)
                    .position(x: model.dragPoint.x, y: model.dragPoint.y)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                model.updateDragPosition(value: value, width: width, height: height)
                            }
                            .onEnded { value in
                                model.endDraging(value: value, didComplete: didComplete, width: width, height: height)
                            }
                    )
            }
            .onAppear {
                model.setUp(width: width, height: height)
            }
    }
}
