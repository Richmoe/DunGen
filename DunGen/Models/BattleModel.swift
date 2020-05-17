//
//  BattleModel.swift
//  DunGen
//
//  Created by Richard Moe on 5/16/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation



/* Battle is:
 Encounter obj
 Party obj
 Initiative
 Battle order management
 
 
 */

class Battle {
    
    let encounter: Encounter
    
    let party: Party
    
    var initiative: [(Int, Mob)] = []
    
    var current = -1
    var round = 1
    
    
    init (encounter: Encounter, party: Party) {
        self.encounter = encounter
        self.party = party
        generateInitiative()
    }
    
    func generateInitiative() {
        
        var temp : [(Int, Mob)] = []
        //Roll for party
        for p in party.player {
            
            var roll = GetDiceRoll("1d20")
            roll += p.initiativeBonus
            
            temp.append((roll, p))
            
        }
        
        
        //Roll for Encounter mobs
        for m in encounter.mobs {
            var roll = GetDiceRoll("1d20")
            
            roll += m.initiativeBonus
            
            temp.append((roll, m))
        }

        //Sort descending
        initiative = temp.sorted { $0.0 > $1.0}
        
    }
    
    func nextTurn() {
        current += 1
        if (current >= initiative.count) {
            current = 0
            nextRound()
        }
        
        
    }
    
    func nextRound() {
        round += 1
    }
}