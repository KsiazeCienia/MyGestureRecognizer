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
            gesture.addToStrokes(addStroke(points: stroke.points))
        }
    }
    
    func addStroke(points: [CGPoint]) -> StrokeDatabase {
        let databaseStroke = StrokeDatabase(context: context)
        for point in points {
            databaseStroke.addToPoints(addPoint(point: point))
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        return databaseStroke
    }
    
    func addPoint(point: CGPoint) -> Point {
        let databasePoint = Point(context: context)
        databasePoint.x = Float(point.x)
        databasePoint.y = Float(point.y)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        return databasePoint
    }
    
}
