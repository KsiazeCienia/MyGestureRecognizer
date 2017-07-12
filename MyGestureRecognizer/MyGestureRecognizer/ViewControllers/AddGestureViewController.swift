//
//  AddGestureViewController.swift
//  MyGestureRecognizer
//
//  Created by Marcin on 12.07.2017.
//  Copyright © 2017 Marcin Włoczko. All rights reserved.
//

import UIKit

class AddGestureViewController: UIViewController {

    @IBOutlet weak var drawSpace: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    private let database = Database()
    
    //MARK:- Variables
    private var strokes = [Stroke]()
    private var points = [CGPoint]()
    private var lastPoint = CGPoint.zero
    private var isSwiping = false

    @IBAction func saveButton(_ sender: Any) {
        if let name = textField.text {
            let unistroke = Unistroke(name: name)
            unistroke.generateUnistrokePermutations(strokes: strokes)
            database.addGesture(unistroke: unistroke)
        } else {
            //MARK:- TODO wyświetlić komuniakt o podani nazwy
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSwiping = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
            points.append(lastPoint)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSwiping = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            points.append(currentPoint)
            print(currentPoint)
            drawLine(from: lastPoint, to: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isSwiping {
            drawLine(from: lastPoint, to: lastPoint)
        }
        
        let stroke = Stroke(points: points)
        points.removeAll()
        strokes.append(stroke)
//        print("STOP")
//        if (template.isEmpty) {
//            template = points
//            points.removeAll()
//        } else {
//            let unistroke = Unistroke(name: "da")
//            let stroke = Stroke(points: template)
//            unistroke.generateUnistrokePermutations(strokes: [stroke])
//            
//            points = Stroke.resample(points: points, totalPoints: 96)
//            let radians = Stroke.indicativeAngle(points: points)
//            points = Stroke.rotateBy(points: points, radians: -radians)
//            let vector = Stroke.calculateStartUnitVector(points: points)
//            
//            let (match, score) = unistroke.recoginze(points: points, vector: vector, n: 3, multistrokes: [unistroke.unistrokes])
//            print(score)
//            print(match)
//        }
        
    }
    
    private func drawLine(from: CGPoint, to: CGPoint) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        drawSpace.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: from.x, y: from.y))
        context?.addLine(to: CGPoint(x: to.x, y: to.y))
        
        context?.setBlendMode(.normal)
        context?.setLineCap(.round)
        context?.setLineWidth(5)
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.strokePath()
        
        drawSpace.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }


}
