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
    static let theta = CGFloat(45).toRadians()
    static let negativeTheta = CGFloat(-45).toRadians()
    static let delta = CGFloat(2).toRadians()
    static let alpha = CGFloat(30).toRadians()

    //SPROBOWAĆ MANIPULOWAĆ MIĘDZY 0.20-0.35
    static let threshold = CGFloat(0.3)
    static let n = 96
    static let i = 12
    static let phi = CGFloat((0.5)*(-1 + sqrt(5)))
    
    var points: [CGPoint]
    
    init(points: [CGPoint]) {
        self.points = points
    }
    
    //SPRAWDZONE
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
    
    //SPRAWDZONE
    static func calculateStartUnitVector(points: [CGPoint]) -> CGPoint {
        let x = points[i].x - points[0].x
        let y = points[i].y - points[0].y
        let vx = x / sqrt(x * x + y * y)
        let vy = y / sqrt(x * x + y * y)
        return CGPoint(x: vx, y: vy)
    }
    
//    static func optimalCosineDistance(v1: [CGPoint], v2: [CGPoint]) -> CGFloat {
//        var a = CGFloat(0)
//        var b = CGFloat(0)
//        for i in 0 ..<
//    }
//    
    //SPRAWDZONE
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
    
    //SPRAWDZONE
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
    
    //SPRAWDZONE
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
    
    //SPRAWDZONE
    static func distanceAtAngle(points: [CGPoint], templatePoints: [CGPoint], angle: CGFloat) -> CGFloat {
        let newPoints = Stroke.rotateBy(points: points, radians: angle)
        return Stroke.pathDistance(points: newPoints, templatePoints: templatePoints)
        
    }
    
    //DOWIEDZIEĆ SIĘ CZY NA PEWNO TEN MIN MOZE BYĆ
    static func pathDistance(points: [CGPoint], templatePoints: [CGPoint]) -> CGFloat {
        var length = CGFloat(0)
        let count = min(points.count, templatePoints.count)
        for i in 0 ..< count {
            length += points[i].distanceTo(point: templatePoints[i])
        }
        return (length / CGFloat(count))
    }
    
    //SPRAWDZONE
    static func indicativeAngle(points: [CGPoint]) -> CGFloat {
        let center = centroid(points: points)
        return atan2(center.y - points[0].y, center.x - points[0].x)
    }
    
    //SPRAWDZONE
    static func resample(points: [CGPoint], totalPoints: Int) -> [CGPoint] {
        var initialPoints = points
        let interval = pathLength(points: initialPoints) / CGFloat(totalPoints - 1)
        var totalLength = CGFloat(0)
        var newPoints = [points[0]]
        for i in 1 ..< initialPoints.count {
            let currentLength = initialPoints[i-1].distanceTo(point: initialPoints[i])
            if ((totalLength + currentLength) >= interval) {
                let qx = initialPoints[i-1].x + ((interval - totalLength) / currentLength) * (initialPoints[i].x - initialPoints[i-1].x)
                let qy = initialPoints[i-1].y + ((interval - totalLength) / currentLength) * (initialPoints[i].y - initialPoints[i-1].y)
                let q = CGPoint(x: qx, y: qy)
                newPoints.append(q)
                initialPoints.insert(q, at: i)
                totalLength = CGFloat(0)
            } else {
                totalLength += currentLength
            }
        }
        if newPoints.count == totalPoints-1 {
            newPoints.append(points.last!)
        }
        return newPoints
    }
    
    //SPRAWDZONE
    static func pathLength(points: [CGPoint]) -> CGFloat {
        var length = CGFloat(0)
        for i in 1 ..< points.count {
            length += points[i].distanceTo(point: points[i - 1])
        }
        return length
    }
    
    //SPRAWDZONE
    static func centroid(points: [CGPoint]) -> CGPoint {
        var totalWidth = CGFloat(0)
        var totalHeigth = CGFloat(0)
        for point in points {
            totalWidth += point.x
            totalHeigth += point.y
        }
        return CGPoint(x: (totalWidth / CGFloat(points.count)), y: (totalHeigth / CGFloat(points.count)))
    }
    
    //UPEWNIC SIĘ
    static func angleBetweenVectors(a: CGPoint, b: CGPoint) -> CGFloat {
        return acos(a.x * b.x + a.y * b.y)
    }
    
    //SPRWDZONE
    static func combineStrokes(strokes: [Stroke]) -> [CGPoint] {
        var points = [CGPoint]()
        for stroke in strokes {
            points += stroke.points
        }
        return points
    }
    
    static func recoginze(strokes: [Stroke], multistrokes: [Multistroke]) -> (String, CGFloat) {
        
        var points = Stroke.combineStrokes(strokes: strokes)
        points = Stroke.resample(points: points, totalPoints: Multistroke.n)
        let radians = Stroke.indicativeAngle(points: points)
        points = Stroke.rotateBy(points: points, radians: -radians)
        points = Stroke.scaleToDim(points: points)
        points = Stroke.translateTo(points: points)
        let startVector = Stroke.calculateStartUnitVector(points: points)
    
        var b = CGFloat.infinity
        var bestStroke = ""
        var distance = CGFloat(0)
        for multistroke in multistrokes {
            if multistroke.numberOfStrokes == strokes.count {
                for unistroke in multistroke.unistrokes {
                    let strokeVector = Stroke.calculateStartUnitVector(points: unistroke.points)
                    if ((angleBetweenVectors(a: startVector, b: strokeVector)) < alpha) {
                        distance = Stroke.distanceAtBestAngle(points: points, templatePoints: unistroke.points, fromAngle: Stroke.negativeTheta, toAngle: Stroke.theta, delta: delta)
                        //MARK:- TODO sprwdzić
                        if distance < b {
                            b = distance
                            bestStroke = multistroke.name
                        }
                    }
                }
            }
        }
        let score = 1 - b/(0.5*sqrt(Stroke.size*Stroke.size + Stroke.size*Stroke.size))
        return (bestStroke, score)
    }
}
