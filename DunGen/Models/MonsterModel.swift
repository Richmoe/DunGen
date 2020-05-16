//
//  MonsterModel.swift
//  DunGen
//
//  Created by Richard Moe on 5/10/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation


class Monster: Mob {
    
    var challengeRating  = 0.0
    var hitDice = "1d6"
    var attackDice = "1d6"
    
    init(name: String, armorClass: Int, hitPoints: Int, initiativeBonus: Int, image: String, hitDice: String, challengeRating: Double)
    {
        self.challengeRating = challengeRating
        self.hitDice = hitDice
        super.init(name: name, armorClass: armorClass, hitPoints: hitPoints, initiativeBonus: initiativeBonus, image: image)
    }
    
    func makeMob() -> Monster {
        
        let newMob = Monster(name: name, armorClass: armorClass, hitPoints: hitPoints, initiativeBonus: initiativeBonus, image: image, hitDice: hitDice, challengeRating: challengeRating)
        
        newMob.setHPs()
        return newMob
    }
    
    func setHPs() {
        
        //convert HitDice to HitPoints
        
        self.hitPoints = GetDiceRoll(hitDice)
        print ("Making \(self.name) with \(self.hitPoints) HPs \(self.hitDice)")
        
    }
}
