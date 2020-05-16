//
//  MapController.swift
//  DunGen
//
//  Created by Richard Moe on 5/7/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation


class MapController {
    
    var dungeon : Dungeon
    var mapHeight: Int
    var mapWidth: Int
    
    init(dungeon: Dungeon) {
        
        self.dungeon = dungeon
        self.mapHeight = dungeon.mapHeight
        self.mapWidth = dungeon.mapWidth
    }
    
    func getPlayerEntrance() -> MapPoint {
        return dungeon.getPlayerEntrance()
    }
    
    
    func move(from: MapPoint, dir: Direction) -> (Bool, MapPoint) {
        
        let mv = getCardinalMoveVector(dir: dir)
        
        let toMP = from + mv
        
        let toType = getBlock(toMP) //mapBlocks[toMP.row][toMP.col]
        
        print("Moving to tile: \(toType.tileCode)")
        
        if (toType.tileCode == TileCode.null) {
            return (false, toMP)
        } else {
            //Check wall
            let dirWall = toType.getWallCode(wallDir: dir.opposite())
            if (dirWall == "W") {
                return (false, toMP)
            } else {
                return (true, toMP)
            }
            
        }
    }
    
    func canSee(from: MapPoint, to: MapPoint) -> Bool {
        
        //All we need is from and which way we're going:
        
        if (dungeon.currentLevel().offScreen(point: to)) {
            return false
        }
        
        let fromBlock = getBlock(from)
        
        let dir = getDirFromVector(to - from)
        
        let dirWall = fromBlock.getWallCode(wallDir: dir)
        
        if (["W","D","S","0"].contains(dirWall)) {
            return false
        } else {
            //now check to walls
            let dirWall = getBlock(to).getWallCode(wallDir: dir.opposite())
            if (["W","D","S","0"].contains(dirWall)) {
                return false
            } else {
                return true
            }
        }
    }
    
    func getBlock(_ pt: MapPoint) -> MapBlock {
        return dungeon.getBlock(pt)
    }
    
    
    
}
