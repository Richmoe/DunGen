//
//  Adventure.swift
//  DunGen
//
//  Created by Richard Moe on 5/15/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation

class Adventure  {
    
    //Map
    var dungeon: Dungeon
    
    //Party
    var party : Party
    //Difficulty
    
    //Set up Encounters
    
    //Manage battles?
    var currentBattle: BattleController?
    var inBattle = true
    //End of Adventure calcs
    
    
    init() {
        party = Party()
        
        dungeon = Dungeon()
    }
    
    func createPlayers() {
        
        var p1 = Player(name: "Cherrydale", level: 1, experience: 0, armorClass: 6, hitPoints: 8, initiativeBonus: 2, avatar: "Avatar1")
        party.addPlayer(p1)
        
        p1 = Player(name: "Tomalot", level: 1, experience: 0, armorClass: 6, hitPoints: 8, initiativeBonus: 2, avatar: "Avatar2")
        party.addPlayer(p1)
        
        p1 = Player(name: "Svenwolf", level: 1, experience: 0, armorClass: 6, hitPoints: 8, initiativeBonus: 2, avatar: "Avatar3")
        party.addPlayer(p1)
        
        p1 = Player(name: "Sookie", level: 1, experience: 0, armorClass: 6, hitPoints: 8, initiativeBonus: 2, avatar: "Avatar4")
        party.addPlayer(p1)
        
    }
    
}
