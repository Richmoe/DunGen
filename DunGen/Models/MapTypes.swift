//
//  MapTypes.swift
//  AdventureDungeon
//
//  Created bcol Richard Moe on 4/11/20.
//  Copcolright © 2020 Richard Moe. All rights reserved.
//

import Foundation
import SpriteKit



struct MapPoint {
    let row: Int
    let col: Int
}

let MAP_POINT_NULL = MapPoint(row: -1, col: -1)
let MAP_POINT_ERROR = MapPoint(row: -99, col: -99)

func + (left: MapPoint, right: MapPoint) -> MapPoint {
    return MapPoint(row: left.row + right.row, col: left.col + right.col)
}

func += ( left: inout MapPoint, right: MapPoint) {
    left = left + right
}

func - (left: MapPoint, right: MapPoint) -> MapPoint {
    return MapPoint(row: left.row - right.row, col: left.col - right.col)
}

func -= ( left: inout MapPoint, right: MapPoint) {
    left = left - right
}

func * (left: MapPoint, right: Int) ->  MapPoint {
    return MapPoint(row: left.row * right, col: left.col * right)
}

func == (left: MapPoint, right: MapPoint) -> Bool {
    return (left.row == right.row && left.col == right.col)
}

struct Passage {
    let type : PassageType
    let direction: Direction
}


enum PassageType : Int {
    case hallway = 0
    case secret = 1
    case secretLocked = 2
    case wooden
    case woodenLocked
    case woodenBarred
    case stone
    case stoneLocked
    case stoneBarred
    case iron
    case ironLocked
    case ironBarred
    case portcullis
    case portcullisLocked
    case stairsDown
    case stairsUp
    
}

enum Direction : Int {
    case north = 0
    case northeast
    case east
    case southeast
    case south
    case southwest
    case west
    case northwest
    
    func opposite() -> Direction {
        return Direction(rawValue: (self.rawValue + 4) % 8)!
    }
    
    func left() -> Direction {
        return Direction(rawValue: (self.rawValue - 2 + 8) % 8)!
    }
    
    func right() -> Direction {
        return Direction(rawValue: (self.rawValue + 2) % 8)!
    }
    
    func randNESW() -> Direction {
        let dirs = [Direction.north, Direction.east, Direction.south, Direction.west]
        let r = MapGenRand.sharedInstance.getRand(to: 4)
        return dirs[(r - 1)]
    }
}

enum TileCode : Int {
    case null  = 0
    case floor
    case deadend
    case passage
    case passageLeft
    case passageRight // 5
    case crossroad
    case turnLeft
    case turnRight
    
    case doorLeft
    case doorRight // 10
    case doorEnd // 11
    
    case secretLeft
    case secretRight
    case secretEnd
    
    case singleWall
    case singleDoor
    
    case roomUL
    case roomUR
    case roomLL
    case roomLR
    
    case stairsDown
    case stairsUp
    
    
}

func getMoveVector(dir: Direction) -> MapPoint {
    
    let moveVector: MapPoint
    switch dir {
    case .north:
        moveVector = MapPoint(row: 1, col: 0)
    case .east:
        moveVector = MapPoint(row: 0, col: 1)
    case .south:
        moveVector = MapPoint(row: -1, col: 0)
    case .west:
        moveVector = MapPoint(row: 0, col: -1)
    case .northeast:
        moveVector = MapPoint(row: 1, col: 1)
    case .northwest:
        moveVector = MapPoint(row: 1, col: -1)
    case .southeast:
        moveVector = MapPoint(row: -1, col: 1)
    case .southwest:
        moveVector = MapPoint(row: -1, col: -1)
    }
    return moveVector
}

func getCardinalMoveVector(dir: Direction) -> MapPoint {
    
    let moveVector: MapPoint
    switch dir {
    case .north:
        moveVector = MapPoint(row: 1, col: 0)
    case .east:
        moveVector = MapPoint(row: 0, col: 1)
    case .south:
        moveVector = MapPoint(row: -1, col: 0)
    case .west:
        moveVector = MapPoint(row: 0, col: -1)
    default:
        moveVector = MapPoint(row: 0, col: 0)
    }
    return moveVector
}

func getDirFromVector(_ vector: MapPoint) -> Direction {
    
    var dir: Direction = Direction.north
    let col = vector.col
    let row = vector.row
    
    //Redo this but for now:
    switch (row, col) {
    case (1, 0):
        dir = .north
    case (0, 1):
        dir = .east
    case (-1, 0):
        dir = .south
    case (0, -1):
        dir = .west
    case (1, 1):
        dir = .northeast
    case (1, -1):
        dir = .northwest
    case (-1,1):
        dir = .southeast
    case (-1, -1):
        dir = .southwest
    default:
        break
        
    }
    
    return dir
}



func angleToCardinalDir(_ angle: CGFloat) -> Direction {
    
    if (angle < 45.0) {
        return .north
    } else if (angle < 135.0) {
        return .east
    } else if (angle < 225.0) {
        return .south
    } else if (angle < 315.0) {
        return .west
    } else {
        return .north
    }
}



//Returns FP angles from 0.0..<360.0, where 0 = N, 90 = E
func angleBetween(fromPt: CGPoint, toPt: CGPoint) -> CGFloat {
    
    let radiansToDegrees = 180 / CGFloat.pi
    
    //let angle = atan2(toPt.x - fromPt.x, toPt.y - fromPt.y)
    let angle = atan2(fromPt.x - toPt.x, fromPt.y - toPt.y)

    return (angle * radiansToDegrees + 180.0)
}

func angleBetween(fromMap: MapPoint, toMap: MapPoint) -> CGFloat {
    
    let radiansToDegrees = 180 / CGFloat.pi
    
    //let angle = atan2(toPt.x - fromPt.x, toPt.y - fromPt.y)
    let angle = atan2(CGFloat(fromMap.col - toMap.col), CGFloat(fromMap.row - toMap.row))

    return (angle * radiansToDegrees + 180.0)
}
