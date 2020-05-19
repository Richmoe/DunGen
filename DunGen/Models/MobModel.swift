//
//  MobModel.swift
//  DunGen
//
//  Created by Richard Moe on 5/10/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation

class Mob {
    
    
    let uid:UUID?
    
    var name: String

    
    var armorClass: Int
    var hitPoints: Int
    var maxHitPoints: Int
    
    var image: String  //for now, an image
    
    var initiativeBonus = 0
    
    init(name: String, armorClass: Int, hitPoints: Int, initiativeBonus: Int, image: String)
    {
        self.uid = UUID()
        self.name = name
        self.armorClass = armorClass
        self.hitPoints = hitPoints
        self.maxHitPoints = hitPoints
        self.image = image
        self.initiativeBonus = initiativeBonus
        
    }
}
