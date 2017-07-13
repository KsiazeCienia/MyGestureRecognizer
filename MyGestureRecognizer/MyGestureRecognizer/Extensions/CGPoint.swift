//
//  CGPoint.swift
//  MyGestureRecognizer
//
//  Created by Marcin on 08.07.2017.
//  Copyright © 2017 Marcin Włoczko. All rights reserved.
//

import UIKit

extension CGPoint {
    func distanceTo(point: CGPoint) -> CGFloat {
        let x = point.x - self.x
        let y = point.y - self.y
        return sqrt(x * x + y * y)
    }
}
