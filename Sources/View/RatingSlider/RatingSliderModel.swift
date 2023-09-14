//
//  File.swift
//  
//
//  Created by Ayoub on 11/9/2023.
//

import Foundation
import SwiftUI


extension RatingSlider {
    class Model: ObservableObject {
        
        private var _rateItemList = [RateItem]()
        var rateItemList: [RateItem] { get { return _rateItemList } }
        
        @Published private var _dragPoint = CGPoint(x: 0, y: 0)
        var dragPoint: CGPoint { get { return _dragPoint } }
        
        @Published private var _icon = ""
        var icon: String { get { return _icon } }
        
        @Published private var _shimmerStatus: Bool = true
        var shimmerStatus: Bool { get { return _shimmerStatus } }
        
        func setUp(width: CGFloat, height: CGFloat, images: RatingImages) {
            _dragPoint = CGPoint(x: height/2, y: height/2)
            _icon = images.firstImage
            let range = width/4
            for i in 0...4 {
                var x: CGFloat = range * CGFloat(i)
                if x == 0 { x = height/2 }
                if x == width { x = width - height/2 }
                _rateItemList.append(
                    RateItem(
                        value: i,
                        icon: images.getImageByValue(value: i + 1),
                        minX: (range * CGFloat(i)) - range/2,
                        maxX: (range * CGFloat(i)) + range/2,
                        x: x
                    )
                )
            }
        }
        
        func updateDragPosition(value: DragGesture.Value, width: CGFloat, height: CGFloat) {
            if shimmerStatus { _shimmerStatus = false }
            if value.location.x < width - height/2 && value.location.x > height/2 {
                _dragPoint.x = value.location.x
                DispatchQueue.main.async {
                    if let icon = self.getRateItem(value: value.location.x)?.icon { self._icon = icon }
                }
            }
        }
        
        func endDraging(value: DragGesture.Value, didRate: (Int) -> Void) {
            withAnimation {
                let rateItem = getRateItem(value: value.location.x)
                if let x = rateItem?.x { _dragPoint.x = x }
                if let icon = rateItem?.icon { _icon = icon }
                if let value = rateItem?.value { didRate(value) }
            }
        }
        
        struct RateItem {
            let value: Int
            let icon: String
            let minX: CGFloat
            let maxX: CGFloat
            let x: CGFloat
        }
        
        func getRateItem(value: CGFloat) -> RateItem?{
            for item in rateItemList {
                if value > item.minX && value < item.maxX {
                    return item
                }
            }
            return nil
        }
    }
}

public struct RatingImages {
    let firstImage: String
    let secondImage: String
    let thirdImage: String
    let fourthImage: String
    let fifthImage: String
    
    public init(firstImage: String, secondImage: String, thirdImage: String, fourthImage: String, fifthImage: String) {
        self.firstImage = firstImage
        self.secondImage = secondImage
        self.thirdImage = thirdImage
        self.fourthImage = fourthImage
        self.fifthImage = fifthImage
    }
    
    func getImageByValue(value: Int) -> String {
        switch value {
        case 1: return firstImage
        case 2: return secondImage
        case 3: return thirdImage
        case 4: return fourthImage
        case 5: return fifthImage
        default: return firstImage
        }
    }
}
