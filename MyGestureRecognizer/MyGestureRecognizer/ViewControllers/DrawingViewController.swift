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
    @IBOutlet weak var label: UILabel!
    
    private let database = Database()
    
    //MARK:- Variables
    private var points = [CGPoint]()
    private var strokes = [Stroke]()
    private var lastPoint = CGPoint.zero
    private var isSwiping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - TODO potem usunać
        //database.removeAll()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clean(_ sender: Any) {
        drawSpace.image = nil
        strokes.removeAll()
        points.removeAll()
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
        if points.count <= 12 {
            //komunkat o zbyt małej ilośći znaków
        } else {
            let stroke = Stroke(points: points)
            strokes.append(stroke)
            points.removeAll()
            let (match, score) = Stroke.recoginze(strokes: strokes, multistrokes: database.getMultistrokes())
            label.text = match + " " +  String(describing: score)
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

