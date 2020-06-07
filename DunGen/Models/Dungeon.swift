//
//  Dungeon.swift
//  DunGen
//
//  Created by Richard Moe on 5/15/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation


class Dungeon { //Environment?
    
    var current = 0
    
    var level : [Map] = []
    
    let mapWidth = 30
    let mapHeight = 30
    
    init() {
        
        let m = Map(width: mapWidth, height: mapHeight)
        self.level.append(m)
    }
    
    func getPlayerEntrance() -> MapPoint {
        return level[current].entranceLanding
    }
    
    func rebuild() {
        let m = Map(width: mapWidth, height: mapHeight)
        level[current] = m
    }
    
     
    func getBlock(_ pt: MapPoint) -> MapBlock {
        return level[current].getBlock(pt)
    }
    
    func currentLevel() -> Map {
        return level[current]
    }
    
    func canEnter(toPt: MapPoint, moveDir: Direction) -> Bool {
        return currentLevel().canEnter(toPt: toPt, moveDir: moveDir)
    }

    
}
