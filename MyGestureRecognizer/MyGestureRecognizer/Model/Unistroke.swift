//
//  Unistroke.swift
//  MyGestureRecognizer
//
//  Created by Marcin on 08.07.2017.
//  Copyright © 2017 Marcin Włoczko. All rights reserved.
//

import UIKit

public class Unistroke {
    
    var strokesOrder = [Int]()
    var strokes = [Stroke]()
    var permuteStrokeOrders = [Int]()
    var unistrokes = [Stroke]()
    
    func generateUnistrokePermutations(strokes: [Stroke]) {
        for i in 0 ..< strokes.count {
            strokesOrder.append(i)
        }
        heapPermute(n: strokesOrder.count)
        
    }
    
    //MARK:- TODO sprawdzić bo coś szemrane
    func makeUnistroke(strokes: [Stroke], orders: [Int]) {
        for strokeOrder in permuteStrokeOrders {
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
    
    func combineStrokes() -> [CGPoint] {
        var points = [CGPoint]()
        for stroke in strokes {
            points += stroke.points
        }
        return points
    }
}
