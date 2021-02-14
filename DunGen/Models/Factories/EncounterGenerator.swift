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
        let encounterCount = max(4, DGRand.getRand(map.rooms.count / 2))
        //
        for _ in 1...encounterCount {
            
            generateAnEncounter(cr: Global.adventure.challenge)
        }
    }
    
    func generateAnEncounter(cr: Int) {
        
        //Determine if we want 1..n mobs totalling the CR
        
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
        
        let encounterAt = MapPoint(row: rRow, col: rCol) + room.at
        
        //create blank encounter at position
        let e = Encounter(at: encounterAt)
        
        //populate the encounter object
        //Get encounter level:
        
        let randNum = DGRand.getRand(100)
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
        
        let targetExp = Global.party.getPartyTargetEncounterExp(type: diff)
        print ("Target Exp: \(targetExp) \(diff)")
        getMobsForDifficulty(targetExp: targetExp, encounter: e)

        
        
        //store it at the block
        //print("Encounter \(e) at map block: \(encounterAt)")
        map.getBlock(encounterAt).encounter = e
        
        //TODO handle > 4 which means it spans multiple spots? Push that to the battle mode?
        
        
    }
    
    func getMobsForDifficulty(targetExp: Int, encounter: Encounter) {
        
        //Either we get 1 mob at diff, 1+ at diff-1, likely 2+ at diff-2, etc.
        //Get total CR for Exp:
        
        
        //print ("GetMobsForDifficulty: targetExp: \(targetExp)")
        let targetCR = Global.adventure.getCrFromExp(exp: targetExp)
        
        /* TODO: I'll do 3 patterns for now:
        1) 1 Monster at difficulty 10%
        2) Mult Monsters at CR-1   80%
         3) Monster group monsters at CR-2- 10% <<LATER?
 
         //and loop the above until I hit my targetExp
 
 */
        
        
        /* TODO: Rarity - 1-9 relative rarety; 0 = no luck
         also added Motif which is a String representing a TYPE of dungeon
         - Basic
         - Cavern
         - Crypt
         - Dungeon
         - Exotic
         - Magic
         - NA (should be for rarety = 0)
         */
        
        /*
        print("TEST_________________________")
        let crTable = [0.13, 0.25, 0.5, 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0,16.0,17.0,18.0,19.0,20.0]
        for _ in 0...20 {
            let i = DGRand.getRandRand(23)
            let _ = MobFactory.sharedInstance.getMobBy(cr: crTable[i - 1 ])
            
            
        }
        print("/Test")
         */

        var encounterPattern = DGRand.getRandRand(40)
        //encounterPattern = 3
        
        //var x = Global.adventure.crMath(cr: 1.0, mod: -1)
        

        if (encounterPattern <= 10) {
            print("Single Monster @ exp: \(targetCR)")
            let m = MobFactory.sharedInstance.getMobBy(cr: targetCR)
            print("Fighting a \(m.name)")
            encounter.addMonster(MobFactory.sharedInstance.makeMonster(name: m.name))
        } else if (encounterPattern <= 40){
            
            //Scenario 2 for now - multiple of the same kind

            //Doing target CR - 1 so:
            let targCR_minus = Global.adventure.crMath(cr: targetCR, mod: -1 * DGRand.getRandRand(3))
            print("Multiple Monsters @ exp: \(targetCR) : using CR: \(targCR_minus)")
            
            var curExp = 0
            
            var maxMobs = 4 // TODO: Fix this for more than 4
            let m = MobFactory.sharedInstance.getMobBy(cr: targCR_minus)
            repeat {
  
                print ("Fighting a \(m.name)")
                curExp += Global.adventure.getExpFromCr(cr: m.challengeRating)
                encounter.addMonster(MobFactory.sharedInstance.makeMonster(name: m.name))
                maxMobs -= 1
            } while (curExp < targetExp && maxMobs > 0)
            print ("total exp: \(curExp)")
        }
        else if (encounterPattern <= 1010){

            // TODO: This case
            //Scenario 3 - chance of different kinds

            //Doing target CR - 1 so:
            let targCR_minus = Global.adventure.crMath(cr: targetCR, mod: -1 * DGRand.getRandRand(3))
            //print("Multiple mixed Monsters @ exp: \(targetCR) : using CR: \(targCR_minus)")
            
            var curExp = 0
            var m = MobFactory.sharedInstance.getMobBy(cr: targCR_minus)
            repeat {
                if (DGRand.getRandRand(100) < 10) {
                    m = MobFactory.sharedInstance.getMobBy(cr: targCR_minus)
                }
                
                print ("Fighting a \(m.name)")
                curExp += Global.adventure.getExpFromCr(cr: m.challengeRating)
                encounter.addMonster(MobFactory.sharedInstance.makeMonster(name: m.name))
            } while curExp < targetExp
            //print ("total exp: \(curExp)")

        }
    }
}
