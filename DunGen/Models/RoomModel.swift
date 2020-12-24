//
//  RoomModel.swift
//  AdventureDungeon
//
//  Created by Richard Moe on 4/11/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation


class Room {
    
    var width: Int = 0
    var height: Int = 0
    var at: MapPoint
    var floorPlan: [[Int]]
    
    var floorBlocks: [[MapBlock]]
    
    var exitStack: [(MapPoint,Passage)] = []
    
//    var hasEncounter = false
//    var hasTrip = false
//    var hasTreasure = false
    var hasSpecial = false //flag for if the room has something special about it, encounter, etc
    
    init (at: MapPoint, width: Int, height: Int) {
        
        //floor = [[1]]
        
        self.at = at
        self.width = width
        self.height = height
        self.floorPlan = Array(repeating: Array(repeating: 1, count: width ), count: height )
        self.floorBlocks = Array(repeating: Array(repeating: MapBlock(tileCode: TileCode.floor, heading: .north), count: width), count: height)
        createMapBlocks()
    }
    
    init (at: MapPoint) {
        self.at = at
        
        let r = DGRand.sharedInstance.getRand(to: 30)
        switch r {
        case 1...4:
            width = 2
            height = 2
        case 5...8:
            width = 3
            height = 3
        case 9...12:
            width = 4
            height = 4
        case 13...15:
            width = 2
            height = 3
        case 16...18:
            width = 3
            height = 2
        case 19...21:
            width = 3
            height = 4
        case 22...24:
            width = 4
            height = 3
        case 25,26:
            width = 4
            height = 5
        case 27,28:
            width = 5
            height = 4
        case 29:
            width = 5
            height = 8
        case 30:
            width = 8
            height = 5
        default:
            width = 2
            height = 2
        }
        
        self.floorPlan = Array(repeating: Array(repeating: 1, count: width ), count: height )
        self.floorBlocks = Array(repeating: Array(repeating: MapBlock(tileCode: TileCode.floor, heading: .north), count: width), count: height)
        createMapBlocks()
    }
    
    func createMapBlocks() {
        
        //todo this is ugly but repeating above creates same instance of object so we need an object for each grid
        for i in 0..<height {
            for j in 0..<width {
                self.floorBlocks[i][j] = MapBlock(tileCode: TileCode.floor, heading: .north)
            }
        }
        
        
        //Add n/s
        for i in 0..<width {
            self.floorBlocks[0][i].addWall(wallDir: .south)
            self.floorBlocks[height - 1][i].addWall(wallDir: .north)
        }
        
        for i in 0..<height {
            self.floorBlocks[i][0].addWall(wallDir: .west)
            self.floorBlocks[i][width - 1].addWall(wallDir: .east)
        }
    }
    
    func generateRandomExit(entrance: Passage)  -> (MapPoint, Passage){
        
        //get location:
        //Todo: we need to be able to readjust if loc takes us into collision which means we need view into overall map in this classs
        
        let outDir : Direction
        let r = DGRand.sharedInstance.getRand(to: 20)
        switch r {
        case 1...7:
            //opposite
            outDir = entrance.direction.opposite()
        case 8...12:
            //left
            outDir = entrance.direction.left()
        case 13...17:
            //right
            outDir = entrance.direction.right()
        default:
            //Same wall
            outDir = entrance.direction
        }
        
        //get type
        let type = PassageType.hallway
        let passage = Passage(type: type, direction: outDir)
        
        
        let pt = getRandomExit(exit: passage)
        
        return (pt, passage)
    }
    
    func getRandomExit(exit: Passage) -> MapPoint {
        var rowArray = [0]
        var colArray = [0]
        
        //create array of indexes so we can shuffle and walk through, trying until we find one without a wall, or at end of loop
        switch exit.direction {
        case .south:
            colArray = Array(stride(from: 0, to: width, by: 1))
        case .east:
            rowArray = Array(stride(from: 0, to: height, by: 1))
            colArray = [(width - 1)]
        case .north:
            rowArray = [(height - 1)]
            colArray = Array(stride(from: 0, to: width, by: 1))
        case .west:
            rowArray = Array(stride(from: 0, to: height, by: 1))
            
        default:
            //error out
            print("Default")
        }
        
        let rA = DGRand.sharedInstance.shuffle(array: rowArray)
        let cA = DGRand.sharedInstance.shuffle(array: colArray)
        
        if (floorPlan[rA[0] as! Int][cA[0] as! Int] == 1) {
            
            return MapPoint(row: rA[0] as! Int, col: cA[0] as! Int)
        } else {
            
            //print("No space for exit on \(exit.direction) wall. Aborting.")
            return MapPoint(row: -1, col: -1)
        }
    }
    
    func setExit(at: MapPoint, exit: Passage) {
        let r = at.row
        let c = at.col
        
        floorPlan[r][c] = exit.direction.rawValue
        
        floorBlocks[r][c].addCode(exit: exit)
    }
    
    
    func getExitCount() -> Int {
        let range: [Int]
        
        if (width >= 5 || height >= 5) {
            //For large rooms:
            range = [3,8,13,17,18,19,20]
        } else {
            range = [5,12,16,20]
        }
        //let rand = Int.random(in: 1...range.last!)
        let rand = DGRand.sharedInstance.getRand(to: range.last!)
        for i in 0...range.count {
            if rand <= range[i] {
                return i
            }
        }
        return range.last!
    }
    
}
