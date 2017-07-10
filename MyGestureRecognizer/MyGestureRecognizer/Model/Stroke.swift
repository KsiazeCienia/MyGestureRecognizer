//
//  Stroke.swift
//  MyGestureRecognizer
//
//  Created by Marcin on 08.07.2017.
//  Copyright © 2017 Marcin Włoczko. All rights reserved.
//

import UIKit

public class Stroke {
    
    let size = CGFloat(250)
    let alpha = 30
    let n = 96
    
    var points: [CGPoint]
    
    public init(points: [CGPoint]) {
        self.points = points
    }
    
    public func addPoint(point: CGPoint) {
        points.append(point)
    }
    
    func scaleDimTo(points: [CGPoint]) {
        
    }
    
    //MARK:- TODO pamiętać o radianach
    func rotateBy(points: [CGPoint], radians: CGFloat) -> [CGPoint] {
        let center = centroid(points: points)
        var newPoints = [CGPoint]()
        for point in points {
            let x = (point.x - center.x)*cos(radians) - (point.y - center.y)*sin(radians) + center.x
            let y = (point.x - center.x)*sin(radians) + (point.y - center.y)*cos(radians) + center.y
            newPoints.append(CGPoint(x: x, y: y))
        }
        return newPoints
    }
    
    func indicativeAngle(points: [CGPoint]) -> CGFloat {
        let center = centroid(points: points)
        return atan2(center.y - points[0].y, center.x - points[0].x)
    }
    
    func resample(points: [CGPoint], totalPoints: Int) -> [CGPoint] {
        let avarageLength = pathLength(points: points) / CGFloat((totalPoints - 1))
        var currentLength = CGFloat(0)
        var actualPoints = points
        var newPoints = [points[0]]
        for i in 1 ..< points.count {
            let length = points[i].distanceTo(point: points[i - 1])
            if (currentLength + length) > avarageLength {
                let x = points[i - 1].x + ((avarageLength - currentLength) / length) * (points[i].x - points[i - 1].x)
                let y = points[i - 1].x + ((avarageLength - currentLength) / length) * (points[i].y - points[i - 1].y)
                let q = CGPoint(x: x, y: y)
                newPoints.append(q)
                actualPoints.append(q)
                currentLength = CGFloat(0)
            } else {
                currentLength += length
            }
        }
        return newPoints
    }
    
    func pathLength(points: [CGPoint]) -> CGFloat {
        var length = CGFloat(0)
        for i in 1 ..< points.count {
            length += points[i].distanceTo(point: points[i - 1])
        }
        return length
    }
    
    func centroid(points: [CGPoint]) -> CGPoint {
        var totalWidth = CGFloat(0)
        var totalHeigth = CGFloat(0)
        for point in points {
            totalWidth += point.x
            totalHeigth += point.y
        }
        return CGPoint(x: (totalWidth / CGFloat(points.count)), y: (totalHeigth / CGFloat(points.count)))
    }
}
