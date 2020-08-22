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
        //Get encounter level:
        
        let randNum = MapGenRand.sharedInstance.getRand(to: 100)
        var diff : String
        if (randNum < 75) {
            diff = "Easy"
        } else {
            if (randNum < 95) {
                diff = "Medium"
            } else {
                if (randNum < 99) {
                    diff = "Hard"
                } else {
                    diff = "Deadly!"
                }
            }
        }
        
        var targetExp = Global.party.getPartyDifficulty(type: diff)
        getMobsForDifficulty(targetExp: targetExp)

        
        
        //store it at the block
        map.getBlock(encounterAt).encounter = e
        
        //TODO handle > 4 which means it spans multiple spots? Push that to the battle mode?
        
        
    }
    
    func getMobsForDifficulty(targetExp: Int) {
        
        //Either we get 1 mob at diff, 1+ at diff-1, likely 2+ at diff-2, etc.
        //Get total CR for Exp:
        
        let x = Global.adventure.getCrFromExp(exp: targetExp)
        
        
        for xx in [100, 225, 400, 1000, 1350, 3899, 4000] {
            
            print ("CER for \(xx): \(Global.adventure.getCrFromExp(exp: xx))")
        }
        
        
        


        
        
    }
    
}
