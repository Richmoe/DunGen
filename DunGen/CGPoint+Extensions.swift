//
//  CGPoint+Extensions.swift
//  AdventureDungeon
//
//  Created by Richard Moe on 4/5/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation
import GameKit


public func + (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func += ( left: inout CGPoint, right: CGPoint) {
  left = left + right
}

public func - (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

public func -= ( left: inout CGPoint, right: CGPoint) {
  left = left - right
}

public func normalize(pt: CGPoint) -> CGPoint {
    
    let maxLen = max(abs(pt.x), abs(pt.y))

    return (CGPoint(x: pt.x / maxLen, y: pt.y / maxLen))
}
