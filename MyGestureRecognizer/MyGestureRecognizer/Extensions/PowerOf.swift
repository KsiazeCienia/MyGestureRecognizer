//
//  PowerOf.swift
//  MyGestureRecognizer
//
//  Created by Marcin on 10.07.2017.
//  Copyright © 2017 Marcin Włoczko. All rights reserved.
//

import Foundation

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
