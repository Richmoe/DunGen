//
//  TreasureGenerator.swift
//  DunGen
//
//  Created by Richard Moe on 1/23/21.
//  Copyright © 2021 Richard Moe. All rights reserved.
//

import Foundation


class TreasureGenerator {
    
    //Need: Map/rooms, what level, overall adventure target difficulty/CR, theme?,
    
    let map: Map
    
    init(map: Map) {
        self.map = map
        generateTreasures()
        
    }
    
    func generateTreasures () {
        
        //calculate how many we want for the dungeon / divided by # of levels based on overall CR rating
        //let treasureCount = max(1, DGRand.getRand(map.rooms.count / 8))
        let treasureCount = 4
        //
        for _ in 1...treasureCount {
            
            generateTreasure(cr: Global.adventure.challenge)
        }
    }
    
    func generateTreasure(cr: Int) {
        
         var room: Room
        
        //Find a room that doesn't have anything special in it
        repeat {
            //find an unused room
            let rNum = DGRand.getRand(map.rooms.count) - 1 //0based
            //print ("Placing in room: \(rNum)")
            
            room = map.rooms[rNum]
            
        } while (room.hasSpecial == true)
        
        //Flag room as a special
        room.hasSpecial = true
        
        //position within room:
        
        let rRow = DGRand.getRand(room.height) - 1 //0based
        let rCol = DGRand.getRand(room.width) - 1
        
        let treasureAt = MapPoint(row: rRow, col: rCol) + room.at
        
        //create blank encounter at position
        //let e = Encounter(at: encounterAt)
        let loot = LootFactory.sharedInstance.getTreasureHoard(cr: cr)
        

        //store it at the block
        map.getBlock(treasureAt).treasure = Drop(type: 2, name: "Treasure Chest", loot: loot)
        
        room.treasure = loot
        print("Generated treasure at \(treasureAt)")
        
    }
    
    
}
