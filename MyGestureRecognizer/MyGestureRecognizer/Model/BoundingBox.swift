//
//  BoundingBox.swift
//  MyGestureRecognizer
//
//  Created by Marcin on 11.07.2017.
//  Copyright © 2017 Marcin Włoczko. All rights reserved.
//

import UIKit

struct BoundingBox {
    var minX: CGFloat
    var maxX: CGFloat
    var minY: CGFloat
    var maxY: CGFloat
    
    init(points: [CGPoint]) {
        minX = CGFloat.infinity
        minY = CGFloat.infinity
        maxX = -CGFloat.infinity
        maxY = -CGFloat.infinity
        for point in points {
            minX = min(point.x, minX)
            minY = min(point.y, minY)
            maxX = max(point.x, maxX)
            maxY = max(point.y, maxY)
        }
    }
    
    func getHeight() -> CGFloat {
        return maxY - minY
    }
    
    func getWidth() -> CGFloat {
        return maxX - minX
    }
}
