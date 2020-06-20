//
//  EncounterGenerator.swift
//  DunGen
//
//  Created by Richard Moe on 6/17/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation


class EncounterGenerator {
    
    //Need: Map/rooms, what level, overall adventure target difficulty/CR, theme?,
    
    let map: Map
    
    init(map: Map) {
        self.map = map
        generateEncounters()
        
    }
    
    func generateEncounters () {
        
        //calculate how many we want for the dungeon / divided by # of levels based on overall CR rating
        let encounterCount = min(4, map.rooms.count - 1)
        //
        for _ in 1...encounterCount {
            
            generateAnEncounter(cr: 0)
        }
    }
    
    func generateAnEncounter(cr: Int) {
        
        //Determine if we want 1..n mobs totalling the CR
        
        var room: Room
        
        //Find a room that doesn't have anything special in it
        repeat {
            //find an unused room
            let rNum = MapGenRand.sharedInstance.getRand(to: map.rooms.count) - 1 //0based
            //print ("Placing in room: \(rNum)")
            
            room = map.rooms[rNum]
            
        } while (room.hasSpecial == true)
        
        //position within room:
        
        let rRow = MapGenRand.sharedInstance.getRand(to: room.height) - 1 //0based
        let rCol = MapGenRand.sharedInstance.getRand(to: room.width) - 1
        
        let encounterAt = MapPoint(row: rRow, col: rCol) + room.at
        
        //create blank encounter at position
        let e = Encounter(at: encounterAt)
        
        //populate the encounter object
        
        
        //store it at the block
        map.getBlock(encounterAt).encounter = e
        
        //TODO handle > 4 which means it spans multiple spots? Push that to the battle mode?
        
        
    }
    
    
}
