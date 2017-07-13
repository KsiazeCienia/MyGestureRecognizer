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
    
    //MARK:- TODO poprawić
    func removeAll() {
        let DelAllPoints = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Point"))
        let DelAllUnistroke = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "UnistrokeDatabase"))
        let DelAllGestures = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Gesture"))
        do {
            try context.execute(DelAllPoints)
            try context.execute(DelAllUnistroke)
            try context.execute(DelAllGestures)
        }
        catch {
            print(error)
        }
    }
    
    func addGesture(multistroke: Multistroke) {
        let gesture = Gesture(context: context)
        gesture.name = multistroke.name
        gesture.numberOfStrokes = Int16(multistroke.numberOfStrokes)
        for unistroke in multistroke.unistrokes {
            gesture.addToUnistrokes(convertUnistroke(points: unistroke.points))
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func convertUnistroke(points: [CGPoint]) -> UnistrokeDatabase {
        let databaseUnistroke = UnistrokeDatabase(context: context)
        for point in points {
            databaseUnistroke.addToPoints(convertPoint(point: point))
        }
        return databaseUnistroke
    }
    
    func convertPoint(point: CGPoint) -> Point {
        let databasePoint = Point(context: context)
        databasePoint.x = Float(point.x)
        databasePoint.y = Float(point.y)
        return databasePoint
    }
    
    func getMultistrokes() -> [Multistroke] {
        var gestures = [Gesture]()
        var multistrokes = [Multistroke]()
        do {
            gestures = try context.fetch(Gesture.fetchRequest())
        } catch {
            print("Fetching failed")
        }
        
        for gesture in gestures {
            if let actualUnistrokes = gesture.unistrokes?.allObjects {
                let unistrokes = parsedUnistrokes(databaseUnistrokes: (actualUnistrokes as! [UnistrokeDatabase]))
                if let actualName = gesture.name {
                    let multistroke = Multistroke(name: actualName, unistrokes: unistrokes, numberOfStrokes: Int(gesture.numberOfStrokes))
                    multistrokes.append(multistroke)
                }
            }
        }
        return multistrokes
    }
    
    func parsedUnistrokes(databaseUnistrokes: [UnistrokeDatabase]) -> [Unistroke] {
        var unistrokes = [Unistroke]()
        for unistroke in databaseUnistrokes {
            if let actualPoints = unistroke.points?.allObjects {
                let parsedPoints = parsePoints(databasePoints: (actualPoints as! [Point]))
                unistrokes.append(Unistroke(points: parsedPoints))
            }
        }
        return unistrokes
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
