//
//  Unistroke.swift
//  MyGestureRecognizer
//
//  Created by Marcin on 08.07.2017.
//  Copyright © 2017 Marcin Włoczko. All rights reserved.
//

import UIKit

public class Unistroke {
    
    static let size = CGFloat(250)
    static let alpha = CGFloat(30).toRadians()
    static let n = 96
    static let theta = CGFloat(45).toRadians()
    static let negativeTheta = CGFloat(-45).toRadians()
    static let delta = CGFloat(2).toRadians()
    
    private var strokesOrder = [Int]()
    private var permuteStrokeOrders = [Int]()
    var strokes = [Stroke]()
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, strokes: [Stroke]) {
        self.name = name
        self.strokes = strokes
        generateUnistrokePermutations()
    }
    
    init(name: String, withPermutatedStrokes strokes: [Stroke]) {
        self.name = name
        self.strokes = strokes
    }
    
    func generateUnistrokePermutations() {
        for i in 0 ..< strokes.count {
            strokesOrder.append(i)
        }
        heapPermute(n: strokesOrder.count)
        makeUnistroke()
        for stroke in strokes {
            stroke.points = Stroke.resample(points: stroke.points, totalPoints: Unistroke.n)
            let radians = Stroke.indicativeAngle(points: stroke.points)
            stroke.points = Stroke.rotateBy(points: stroke.points, radians: -radians)
            stroke.points = Stroke.scaleToDim(points: stroke.points)
            //MARK:TODO brak checkRestoreOrientation
            stroke.points = Stroke.translateTo(points: stroke.points)
        }
        
    }
    
    static func recoginze(points: [CGPoint], vector: CGPoint, n: Int, multistrokes: [Unistroke]) -> (String, CGFloat) {
        var b = CGFloat.infinity
        var bestStroke = ""
        var length = CGFloat(0)
        for multistroke in multistrokes {
            for stroke in multistroke.strokes {
                let strokeVector = Stroke.calculateStartUnitVector(points: stroke.points)
                if ((angleBetweenVectors(a: vector, b: strokeVector)) < alpha) {
                   length = Stroke.distanceAtBestAngle(points: points, templatePoints: stroke.points, fromAngle: negativeTheta, toAngle: theta, delta: 0.8)
                    //MARK:- TODO sprwdzić
                    if length < b {
                        b = length
                        bestStroke = multistroke.name
                    }
                }
            }
        }
        let score = 1 - b/(0.5*sqrt(size*size + size*size))
        return (bestStroke, score)
    }
    
    //MARK:- TODO tu też te pierońskie kąty
    static func angleBetweenVectors(a: CGPoint, b: CGPoint) -> CGFloat {
        return acos(a.x * b.x + a.y * b.y)
    }
    
    //MARK:- TODO sprawdzić bo coś szemrane
    func makeUnistroke() {
        for _ in permuteStrokeOrders {
            for b in 0 ..< 2^^permuteStrokeOrders.count {
                for i in 0 ..< permuteStrokeOrders.count {
                    let strokeIndex = strokesOrder[i]
                    let stroke = strokes[strokeIndex]
                    //MARK:- TODO poczytać o tym
                    var points = [CGPoint]()
                    if ((b >> i) & 1) == 1 {
                        points = stroke.points.reversed()
                    } else {
                        points = stroke.points
                    }
                    strokes.append(Stroke(points: points))
                }
            }
        }
    }
    
    func heapPermute(n: Int){
        if n == 1 {
           permuteStrokeOrders += strokesOrder
        } else {
            for i in 0 ... n {
                heapPermute(n: n - 1)
                if (n % 2) == 1 {
                    let tmp = strokesOrder[0]
                    strokesOrder[0] = strokesOrder[n - 1]
                    strokesOrder[n - 1] = tmp
                } else {
                    let tmp = strokesOrder[i]
                    strokesOrder[i] = strokesOrder[n - 1]
                    strokesOrder[n - 1] = tmp
                }
            }
        }
    }
    
    static func combineStrokes(strokes: [Stroke]) -> [CGPoint] {
        var points = [CGPoint]()
        for stroke in strokes {
            points += stroke.points
        }
        return points
    }
}
