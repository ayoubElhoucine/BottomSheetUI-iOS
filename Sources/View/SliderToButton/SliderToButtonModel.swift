//
//  File.swift
//  
//
//  Created by Ayoub on 11/9/2023.
//

import Foundation
import SwiftUI

extension SliderToButton {
    public enum Mode {
        case slider, button
    }
}

extension SliderToButton {
    class Model: ObservableObject {
        
        private var _stepItemList = [StepItem]()
        var stepItemList: [StepItem] { get { return _stepItemList } }
        
        @Published private var _dragPoint = CGPoint(x: 0, y: 0)
        var dragPoint: CGPoint { get { return _dragPoint } }
        
        @Published private var _shimmerStatus: Bool = true
        var shimmerStatus: Bool { get { return _shimmerStatus } }
        
        @Published private var _calculatedWidth: CGFloat = 0
        var calculatedWidth: CGFloat { get { return _calculatedWidth } }
        
        @Published private var _mode: Mode = .slider
        var mode: Mode { get { return _mode } }
        
        func setUp(width: CGFloat, height: CGFloat) {
            _dragPoint = CGPoint(x: height/2, y: height/2)
            for i in 0...1 {
                var x: CGFloat = width * CGFloat(i)
                if x == 0 { x = height/2 }
                if x == width { x = width - height/2 }
                _stepItemList.append(
                    Model.StepItem(
                        value: i,
                        minX: (width * CGFloat(i)) - width/2,
                        maxX: (width * CGFloat(i)) + width/2,
                        x: x
                    )
                )
            }
        }
        
        func bgWidth(height: CGFloat) -> CGFloat {
            return calculatedWidth - dragPoint.x + height/2
        }
        
        func showTitle(width: CGFloat, height: CGFloat) -> Bool {
            return dragPoint.x < width/2 - height/2
        }
        
        func updateDragPosition(value: DragGesture.Value, width: CGFloat, height: CGFloat) {
            if shimmerStatus { _shimmerStatus = false }
            if value.location.x < width - height/2 && value.location.x > height/2 {
                _dragPoint.x = value.location.x
            }
        }
        
        func endDraging(value: DragGesture.Value, didFinishSliding: () -> Void, width: CGFloat, height: CGFloat) {
            withAnimation {
                let item = getStepItem(value: value.location.x)
                if let x = item?.x { _dragPoint.x = x }
                if item?.boolValue == true {
                    didFinishSliding()
                    updateMode(.button, width: width, height: height)
                }
            }
        }
        
        func updateMode(_ mode: Mode, width: CGFloat, height: CGFloat) {
            withAnimation {
                if mode == .slider {
                    self._calculatedWidth = width
                } else {
                    self._calculatedWidth = height
                    self._dragPoint.x = height/2
                }
                self._mode = mode
            }
        }
        
        struct StepItem {
            let value: Int
            let minX: CGFloat
            let maxX: CGFloat
            let x: CGFloat
            
            var boolValue: Bool {
                get {
                    if value == 0 {
                        return false
                    } else {
                        return true
                    }
                }
            }
        }
        
        func getStepItem(value: CGFloat) -> StepItem? {
            for item in stepItemList {
                if value > item.minX && value < item.maxX {
                    return item
                }
            }
            return nil
        }
    }
}
