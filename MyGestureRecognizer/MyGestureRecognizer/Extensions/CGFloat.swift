//
//  Double.swift
//  MyGestureRecognizer
//
//  Created by Marcin on 10.07.2017.
//  Copyright © 2017 Marcin Włoczko. All rights reserved.
//

import UIKit

extension CGFloat {
    public func toRadians() -> CGFloat {
        let radians = self * CGFloat(M_PI) / 180
        return radians
    }
}
