//
//  Multistroke.swift
//  MyGestureRecognizer
//
//  Created by Marcin on 13.07.2017.
//  Copyright © 2017 Marcin Włoczko. All rights reserved.
//

import UIKit

final class Multistroke {
    
    static let n = 96
    
    private var strokesOrder = [Int]()
    private var permuteStrokeOrders = [[Int]]()
    
    var numberOfStrokes: Int
    var unistrokes = [Unistroke]()
    var name: String
    
    init(name: String, strokes: [Stroke]) {
        self.name = name
        numberOfStrokes = strokes.count
        generateUnistrokePermutations(strokes: strokes)
    }
    
    init(name: String, unistrokes: [Unistroke], numberOfStrokes: Int) {
        self.name = name
        self.unistrokes = unistrokes
        self.numberOfStrokes = numberOfStrokes
    }
    
    private func generateUnistrokePermutations(strokes: [Stroke]) {
        for i in 0 ..< strokes.count {
            strokesOrder.append(i)
        }
        heapPermute(n: strokes.count)
        let unistrokesToPermute = makeUnistroke(strokes: strokes)
        for unistroke in unistrokesToPermute {
            unistroke.points = Stroke.resample(points: unistroke.points, totalPoints: Multistroke.n)
            let radians = Stroke.indicativeAngle(points: unistroke.points)
            unistroke.points = Stroke.rotateBy(points: unistroke.points, radians: -radians)
            unistroke.points = Stroke.scaleToDim(points: unistroke.points)
            //MARK:TODO brak checkRestoreOrientation
            unistroke.points = Stroke.translateTo(points: unistroke.points)
            unistrokes.append(unistroke)
        }
        
    }
    
    private func makeUnistroke(strokes: [Stroke]) -> [Unistroke] {
        var actualStrokes = strokes
        var unistrokes = [Unistroke]()
        for order in permuteStrokeOrders {
            for b in 0 ..< 2^^order.count {
                var points = [CGPoint]()
                for i in 0 ..< order.count {
                    let stroke = actualStrokes[order[i]]
                    if ((b >> i) & 1) == 1 {
                        points += stroke.points.reversed()
                    } else {
                        points += stroke.points
                    }
                }
                let unistroke = Unistroke(points: points)
                unistrokes.append(unistroke)
            }
        }
        return unistrokes
    }
    
    private func heapPermute(n: Int){
        if n == 1 {
            permuteStrokeOrders.append(strokesOrder)
        } else {
            for i in 0 ..< n {
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
    
}
