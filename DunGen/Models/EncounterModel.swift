//
//  EncounterModel.swift
//  DunGen
//
//  Created by Richard Moe on 5/14/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation

class Encounter {
    
    //Encounter is a generated list of monsters, their location, and their treasure
    
    
    
    //list of mobs
    var mobs: [Monster] = [Monster]()
    
    // Map location
    
    //Treasure
    
    
    init() {
        
        var m : Monster
        for _ in 1...4 {
            m =  MobFactory.sharedInstance.makeMonster(name: "goblin")
            mobs.append(m)
            
        }
    }
}


