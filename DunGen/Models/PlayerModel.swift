//
//  PlayerModel.swift
//  AdventureDungeon
//
//  Created by Richard Moe on 3/19/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation


class Player : Mob {
    
    
    var level : Int
    var experience: Int
    
    
    init(name: String, level: Int, experience: Int, armorClass: Int, hitPoints: Int, initiativeBonus: Int, avatar: String)
    {
        self.level = level
        self.experience = experience
        
        super.init(name: name, armorClass: armorClass, hitPoints: hitPoints, initiativeBonus: initiativeBonus, image: avatar)

    }
    
    
    
    
}
