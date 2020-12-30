//
//  MonsterModel.swift
//  DunGen
//
//  Created by Richard Moe on 5/10/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation


class Monster: Mob {
    
    var challengeRating  : Double = 0.0
    var hitDice = "1d6"
    var attackDice = "1d6"
    var rarity = 0
    var motif = 0
    
    init(name: String, armorClass: Int, hitPoints: Int, initiativeBonus: Int, image: String, hitDice: String, challengeRating: Double, rarity: Int, motif: Int)
    {
        self.challengeRating = challengeRating
        self.hitDice = hitDice
        self.rarity = rarity
        self.motif = motif

        super.init(name: name, armorClass: armorClass, hitPoints: hitPoints, initiativeBonus: initiativeBonus, image: image)
    }
    
    func makeMob() -> Monster {
        
        let newMob = Monster(name: name, armorClass: armorClass, hitPoints: hitPoints, initiativeBonus: initiativeBonus, image: image, hitDice: hitDice, challengeRating: challengeRating, rarity: rarity, motif: motif)
        
        newMob.setHPs()
        return newMob
    }
    
    func setHPs() {
        
        //convert HitDice to HitPoints
        
        self.hitPoints = GetDiceRoll(hitDice)
        self.maxHitPoints = self.hitPoints
        print ("Making \(self.name) with \(self.hitPoints) HPs \(self.hitDice)")
        
    }
}
