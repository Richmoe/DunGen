//
//  MapTypes.swift
//  AdventureDungeon
//
//  Created bcol Richard Moe on 4/11/20.
//  Copcolright © 2020 Richard Moe. All rights reserved.
//

import Foundation



struct MapPoint {
    let row: Int
    let col: Int
}

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

struct Passage {
    let type : PassageType
    let direction: Direction
}


enum PassageType : Int{
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
    default:
        moveVector = MapPoint(row: 0, col: 0)
    }
    return moveVector
}
