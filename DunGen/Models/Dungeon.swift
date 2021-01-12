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
        
    }
    
    func buildDungeon() {
        var seedString = DGRand.getSeedString()

        
        /* Interesting:
         UCAY - mob behind door
         WPH7 has secret door
         */
        //seedString = "CCNT"
        
        /* Bugs */
        
      
        
        seedString = "DEW4"  //secret door at 7,17 7,18 and 1,22 2,22
        
        
        
        print("THE SEED ___________ \(seedString) ___________")
        DGRand.sharedInstance.setSeed(seedString: seedString)
        
        
        let m = Map(width: mapWidth, height: mapHeight)
        
        let _ = MapGenerator(map: m)
        
        //trap generator 
        
        let _ = EncounterGenerator(map: m)
        
        //m.generate()
        
        self.level.append(m)
    }
    
    func getPlayerEntrance() -> MapPoint {
        
        if let e = level[current].entranceLanding {
            return e
        }
        
        return MapPoint(row: -1, col: -1)
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
