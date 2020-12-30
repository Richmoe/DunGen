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
            let rNum = DGRand.sharedInstance.getRand(to: map.rooms.count) - 1 //0based
            //print ("Placing in room: \(rNum)")
            
            room = map.rooms[rNum]
            
        } while (room.hasSpecial == true)
        
        //position within room:
        
        let rRow = DGRand.sharedInstance.getRand(to: room.height) - 1 //0based
        let rCol = DGRand.sharedInstance.getRand(to: room.width) - 1
        
        let encounterAt = MapPoint(row: rRow, col: rCol) + room.at
        
        //create blank encounter at position
        let e = Encounter(at: encounterAt)
        
        //populate the encounter object
        //Get encounter level:
        
        let randNum = DGRand.sharedInstance.getRand(to: 100)
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
        
        let targetExp = Global.party.getPartyDifficulty(type: diff)
        getMobsForDifficulty(targetExp: targetExp)

        
        
        //store it at the block
        map.getBlock(encounterAt).encounter = e
        
        //TODO handle > 4 which means it spans multiple spots? Push that to the battle mode?
        
        
    }
    
    func getMobsForDifficulty(targetExp: Int) {
        
        //Either we get 1 mob at diff, 1+ at diff-1, likely 2+ at diff-2, etc.
        //Get total CR for Exp:
        
        
        print ("GetMobsForDifficulty: targetExp: \(targetExp)")
        let targetCR = Global.adventure.getCrFromExp(exp: targetExp)
        
        /* TODO - I'll do 3 patterns for now:
        1) 1 Monster at difficulty 10%
        2) Mult Monsters at CR-1   80%
         3) Monster group monsters at CR-2- 10% <<LATER?
 
         //and loop the above until I hit my targetExp
 
 */
        
        
        /* TODO Rarety - 1-9 relative rarety; 0 = no luck
         also added Motif which is a String representing a TYPE of dungeon
         - Basic
         - Cavern
         - Crypt
         - Dungeon
         - Exotic
         - Magic
         - NA (should be for rarety = 0)
         */
        
        
//        print("TEST_________________________")
//
//        print("CR: 1/8, -1: \(Global.adventure.crMath(cr: 0.13, mod: -1))")
//        print("CR: 1, -1: \(Global.adventure.crMath(cr: 1.0, mod: -1))")
//                print("CR: 1/8, 3: \(Global.adventure.crMath(cr: 0.13, mod: 3))")
//        print("CR: 18, 3: \(Global.adventure.crMath(cr: 18.0, mod: 3))")
//
//        print ("/test")
        var encounterPattern = DGRand.getRandRand(10)
        encounterPattern = 3
        
        var x = Global.adventure.crMath(cr: 1.0, mod: -1)
        

        if (encounterPattern <= 10) {
            print("Single Monster @ exp: \(targetCR)")
            let m = MobFactory.sharedInstance.getMobBy(cr: targetCR)
            print("Fighting a \(m.name)")
        } else if (encounterPattern <= 40){
            //Scenario 2 for now - multiple of the same kind

            //Doing target CR - 1 so:
            let targCR_minus = Global.adventure.crMath(cr: targetCR, mod: -1 * DGRand.getRandRand(3))
            print("Multiple Monsters @ exp: \(targetCR) : using CR: \(targCR_minus)")
            
            var curExp = 0
            let m = MobFactory.sharedInstance.getMobBy(cr: targCR_minus)
            repeat {
                
                print ("Fighting a \(m.name)")
                curExp += Global.adventure.getExpFromCr(cr: m.challengeRating)
            } while curExp < targetExp
            print ("total exp: \(curExp)")

        }
        
        else if (encounterPattern <= 100){
            //Scenario 3 - chance of different kinds

            //Doing target CR - 1 so:
            let targCR_minus = Global.adventure.crMath(cr: targetCR, mod: -1 * DGRand.getRandRand(3))
            print("Multiple Monsters @ exp: \(targetCR) : using CR: \(targCR_minus)")
            
            var curExp = 0
            var m = MobFactory.sharedInstance.getMobBy(cr: targCR_minus)
            repeat {
                if (DGRand.getRandRand(100) < 10) {
                    m = MobFactory.sharedInstance.getMobBy(cr: targCR_minus)
                }
                
                print ("Fighting a \(m.name)")
                curExp += Global.adventure.getExpFromCr(cr: m.challengeRating)
            } while curExp < targetExp
            print ("total exp: \(curExp)")

        }
        


        
        
    }
    
}
