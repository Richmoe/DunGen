//
//  PlayerModel.swift
//  AdventureDungeon
//
//  Created by Richard Moe on 3/19/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation


class Player {
    
    let uid:UUID?
    
    var name: String
    //var baseClass: BaseClass
    //var race: Race
    
    var level: Int
    var experience: Int
    
    var armorClass: Int
    var hitPoints: Int
    
    var avatar: String  //for now, an image
    
    init(name: String, level: Int, experience: Int, armorClass: Int, hitPoints: Int, avatar: String)
    {
        self.uid = UUID()
        self.name = name
        self.level = level
        self.experience = experience
        self.armorClass = armorClass
        self.hitPoints = hitPoints
        self.avatar = avatar
        
    }
    
    
    
    
}
