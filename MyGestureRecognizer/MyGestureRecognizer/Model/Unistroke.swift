//
//  Unistroke.swift
//  MyGestureRecognizer
//
//  Created by Marcin on 08.07.2017.
//  Copyright © 2017 Marcin Włoczko. All rights reserved.
//

import UIKit

public class Unistroke {
    
    let size = CGFloat(250)
    let alpha = CGFloat(30)
    let n = 96
    //MARK:- TODO w radianach
    let theta = CGFloat(45).toRadians()
    let negativeTheta = CGFloat(-45).toRadians()
    let delta = CGFloat(2).toRadians()
    
    var strokesOrder = [Int]()
    var permuteStrokeOrders = [Int]()
    var unistrokes = [Stroke]()
    
    func generateUnistrokePermutations(strokes: [Stroke]) {
        for i in 0 ..< strokes.count {
            strokesOrder.append(i)
        }
        heapPermute(n: strokesOrder.count)
        makeUnistroke(strokes: strokes)
        for unistroke in unistrokes {
            unistroke.points = Stroke.resample(points: unistroke.points, totalPoints: n)
            let radians = Stroke.indicativeAngle(points: unistroke.points)
            unistroke.points = Stroke.rotateBy(points: unistroke.points, radians: -radians)
        }
        
    }
    
    func recoginze(points: [CGPoint], vector: CGPoint, n: Int, multistrokes: [[Stroke]]) -> ([Stroke], CGFloat) {
        var b = CGFloat.infinity
        var bestStroke = [Stroke]()
        var length = CGFloat(0)
        for multistroke in multistrokes {
            for unistroke in multistroke {
                let unistrokeVector = Stroke.calculateStartUnitVector(points: unistroke.points)
                if angleBetweenVectors(a: vector, b: unistrokeVector) < alpha.toRadians() {
                   length = Stroke.distanceAtBestAngle(points: points, templatePoints: unistroke.points, fromAngle: negativeTheta, toAngle: theta, delta: 0.8)
                    //MARK:- TODO sprwdzić
                    if length < b {
                        b = length
                        bestStroke = multistroke
                    }
                }
            }
        }
        let score = 1 - b/(0.5*sqrt(size*size + size*size))
        return (bestStroke, score)
    }
    
    //MARK:- TODO tu też te pierońskie kąty
    func angleBetweenVectors(a: CGPoint, b: CGPoint) -> CGFloat {
        return acos(a.x * b.x + a.y * b.y)
    }
    
    //MARK:- TODO sprawdzić bo coś szemrane
    func makeUnistroke(strokes: [Stroke]) {
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
                    unistrokes.append(Stroke(points: points))
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
    
    func combineStrokes(strokes: [Stroke]) -> [CGPoint] {
        var points = [CGPoint]()
        for stroke in strokes {
            points += stroke.points
        }
        return points
    }
}
