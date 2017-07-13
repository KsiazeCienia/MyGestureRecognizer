//
//  Stroke.swift
//  MyGestureRecognizer
//
//  Created by Marcin on 08.07.2017.
//  Copyright © 2017 Marcin Włoczko. All rights reserved.
//

import UIKit

public class Stroke {
    
    static let size = CGFloat(250)
    static let threshold = CGFloat(0.3)
    static let n = 96
    static let i = 12
    static let phi = CGFloat((0.5)*(-1 + sqrt(5)))
    
    var points: [CGPoint]
    
    public init(points: [CGPoint]) {
        self.points = points
    }
    
    public func addPoint(point: CGPoint) {
        points.append(point)
    }
    
    static func translateTo(points: [CGPoint]) -> [CGPoint] {
        let center = Stroke.centroid(points: points)
        let zeroPoint = CGPoint.zero
        var newPoints = [CGPoint]()
        print(zeroPoint)
        for point in points {
            let x = point.x + zeroPoint.x - center.x
            let y = point.y + zeroPoint.y - center.y
            newPoints.append(CGPoint(x: x, y: y))
        }
        return newPoints
    }
    
    static func calculateStartUnitVector(points: [CGPoint]) -> CGPoint {
        let x = points[i].x - points[0].x
        let y = points[i].y - points[0].y
        let vx = x / sqrt(x * x + y * y)
        let vy = y / sqrt(x * x + y * y)
        return CGPoint(x: vx, y: vy)
    }
    
    static func scaleToDim(points: [CGPoint]) -> [CGPoint] {
        let boundingBox = BoundingBox(points: points)
        var newPoints = [CGPoint]()
        for point in points {
            if min(boundingBox.getWidth()/boundingBox.getHeight(), boundingBox.getHeight()/boundingBox.getWidth()) <= threshold {
                let x = (point.x * size)/max(boundingBox.getWidth(), boundingBox.getHeight())
                let y = (point.y * size)/max(boundingBox.getWidth(), boundingBox.getHeight())
                newPoints.append(CGPoint(x: x, y: y))
            } else {
                let x = (point.x * size)/boundingBox.getWidth()
                let y = (point.y * size)/boundingBox.getHeight()
                newPoints.append(CGPoint(x: x, y: y))
            }
        }
        return newPoints
    }
    
    static func rotateBy(points: [CGPoint], radians: CGFloat) -> [CGPoint] {
        let center = centroid(points: points)
        let cosvalue = cos(radians)
        let sinvalue = sin(radians)
        var newPoints = [CGPoint]()
        for point in points {
            let x = (point.x - center.x)*cosvalue - (point.y - center.y)*sinvalue + center.x
            let y = (point.x - center.x)*sinvalue + (point.y - center.y)*cosvalue + center.y
            newPoints.append(CGPoint(x: x, y: y))
        }
        return newPoints
    }
    
    static func distanceAtBestAngle(points: [CGPoint], templatePoints: [CGPoint], fromAngle: CGFloat, toAngle: CGFloat, delta: CGFloat) -> CGFloat {
        var x1 = Stroke.phi*fromAngle + (1 - Stroke.phi)*toAngle
        var f1 = Stroke.distanceAtAngle(points: points, templatePoints: templatePoints, angle: x1)
        var x2 = (1 - Stroke.phi)*fromAngle + Stroke.phi*toAngle
        var f2 = Stroke.distanceAtAngle(points: points, templatePoints: templatePoints, angle: x2)
        var newToAngle = toAngle
        var newFromAngle = fromAngle
        while (abs(newToAngle - newFromAngle) > delta) {
            if f1 < f2 {
                newToAngle = x2
                x2 = x1
                f2 = f1
                x1 = Stroke.phi*fromAngle + (1 - Stroke.phi)*toAngle
                f1 = Stroke.distanceAtAngle(points: points, templatePoints: templatePoints, angle: x1)
            } else {
                newFromAngle = x1
                x1 = x2
                f1 = f2
                x2 = (1 - Stroke.phi)*fromAngle + Stroke.phi*toAngle
                f2 = Stroke.distanceAtAngle(points: points, templatePoints: templatePoints, angle: x2)
            }
        }
        return min(f1, f2)
    }
    
    static func distanceAtAngle(points: [CGPoint], templatePoints: [CGPoint], angle: CGFloat) -> CGFloat {
        let newPoints = Stroke.rotateBy(points: points, radians: angle)
        return Stroke.pathDistance(points: newPoints, templatePoints: templatePoints)
        
    }
    
    static func pathDistance(points: [CGPoint], templatePoints: [CGPoint]) -> CGFloat {
        var length = CGFloat(0)
        let count = min(points.count, templatePoints.count)
        for i in 0 ..< count {
            length += points[i].distanceTo(point: templatePoints[i])
        }
        return (length / CGFloat(count))
    }
    
    static func indicativeAngle(points: [CGPoint]) -> CGFloat {
        let center = centroid(points: points)
        return atan2(center.y - points[0].y, center.x - points[0].x)
    }
    
    static func resample(points: [CGPoint], totalPoints: Int) -> [CGPoint] {
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
    
    static func pathLength(points: [CGPoint]) -> CGFloat {
        var length = CGFloat(0)
        for i in 1 ..< points.count {
            length += points[i].distanceTo(point: points[i - 1])
        }
        return length
    }
    
    static func centroid(points: [CGPoint]) -> CGPoint {
        var totalWidth = CGFloat(0)
        var totalHeigth = CGFloat(0)
        for point in points {
            totalWidth += point.x
            totalHeigth += point.y
        }
        return CGPoint(x: (totalWidth / CGFloat(points.count)), y: (totalHeigth / CGFloat(points.count)))
    }
}
