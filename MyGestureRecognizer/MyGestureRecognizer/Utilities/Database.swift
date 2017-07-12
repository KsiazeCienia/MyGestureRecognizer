//
//  Database.swift
//  MyGestureRecognizer
//
//  Created by Marcin on 12.07.2017.
//  Copyright © 2017 Marcin Włoczko. All rights reserved.
//

import UIKit
import CoreData

final class Database {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addGesture(unistroke: Unistroke) {
        let gesture = Gesture(context: context)
        gesture.name = unistroke.name
        for stroke in unistroke.unistrokes {
            gesture.addToStrokes(convertStroke(points: stroke.points))
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func convertStroke(points: [CGPoint]) -> StrokeDatabase {
        let databaseStroke = StrokeDatabase(context: context)
        for point in points {
            databaseStroke.addToPoints(convertPoint(point: point))
        }
        return databaseStroke
    }
    
    func convertPoint(point: CGPoint) -> Point {
        let databasePoint = Point(context: context)
        databasePoint.x = Float(point.x)
        databasePoint.y = Float(point.y)
        return databasePoint
    }
    
    func getUnistrokes() -> [Unistroke] {
        var gestures = [Gesture]()
        var unistrokes = [Unistroke]()
        do {
            gestures = try context.fetch(Gesture.fetchRequest())
        } catch {
            print("Fetching failed")
        }
        
        for gesture in gestures {
            if let actualStrokes = gesture.strokes?.allObjects {
                let strokes = parseStrokes(databaseStrokes: (actualStrokes as! [StrokeDatabase]))
                if let actualName = gesture.name {
                    let unistroke = Unistroke(name: actualName, strokes: strokes)
                    unistrokes.append(unistroke)
                }
            }
        }
        return unistrokes
    }
    
    func parseStrokes(databaseStrokes: [StrokeDatabase]) -> [Stroke] {
        var strokes = [Stroke]()
        for stroke in databaseStrokes {
            if let actualPoints = stroke.points?.allObjects {
                let parsedPoints = parsePoints(databasePoints: (actualPoints as! [Point]))
                strokes.append(Stroke(points: parsedPoints))
            }
        }
        return strokes
    }
    
    func parsePoints(databasePoints: [Point]) -> [CGPoint] {
        var points = [CGPoint]()
        for databasePoint in databasePoints {
            let point = CGPoint(x: CGFloat(databasePoint.x), y: CGFloat(databasePoint.y))
            points.append(point)
        }
        return points
    }
    
    
}
