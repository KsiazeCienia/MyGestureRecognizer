//
//  ViewController.swift
//  MyGestureRecognizer
//
//  Created by Marcin on 03.07.2017.
//  Copyright © 2017 Marcin Włoczko. All rights reserved.
//

import UIKit

final class DrawingViewController: UIViewController {
    
    //MARK:- IBOutlet's
    @IBOutlet weak var drawSpace: UIImageView!
    
    //MARK:- Variables
    private var points = [CGPoint]()
    private var template = [CGPoint]()
    private var lastPoint = CGPoint.zero
    private var isSwiping = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        print("STOP")
        if (template.isEmpty) {
            template = points
            points.removeAll()
        } else {
            let unistroke = Unistroke()
            let stroke = Stroke(points: template)
            unistroke.generateUnistrokePermutations(strokes: [stroke])
            
            points = Stroke.resample(points: points, totalPoints: 96)
            let radians = Stroke.indicativeAngle(points: points)
            points = Stroke.rotateBy(points: points, radians: -radians)
            let vector = Stroke.calculateStartUnitVector(points: points)
            
            let (match, score) = unistroke.recoginze(points: points, vector: vector, n: 3, multistrokes: [unistroke.unistrokes])
            print(score)
            print(match)
        }
        
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
