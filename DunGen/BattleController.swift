//
//  BattleController.swift
//  DunGen
//
//  Created by Richard Moe on 5/16/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation
import SpriteKit


/* BattleController is:
 Encounter obj
 Party obj
 Initiative
 Battle order management
 
 
 */

class BattleController : ObservableObject {
    
    let encounter: Encounter
    
    let party: Party
    
    var initiative: [(Int, Mob)] = []
    
    @Published var current = 0
    @Published var round = 1
    
    
    init (encounter: Encounter, party: Party) {
        self.encounter = encounter
        self.party = party
        
        generateInitiative()
        
        placeMobs()
    }
    
    func placeMobs() {
        
        //
        
        
        
    }
    
    func moveCurrent(to: CGPoint) {

        
        let (_, m) = initiative[0]
        
        print ("moveCurrent to \(to), at: \(m.at())")
        
        
        let norm = normalizeRounded(to - m.at())
        print ("norm: \(norm)")
        
        m.move(toPt: m.at() + CGPoint(x: norm.x * 64, y: norm.y * 64))
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
        for m in encounter.mob {
            var roll = GetDiceRoll("1d20")
            
            roll += m.initiativeBonus
            
            temp.append((roll, m))
        }
        
        //Sort descending
        initiative = temp.sorted { $0.0 > $1.0}
    }
    
    func nextTurn() {
        current += 1
        current = current % initiative.count
    }
    
    func nextRound() {
        round += 1
        current = 0
    }
}
