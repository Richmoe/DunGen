//
//  MobFactory.swift
//  DunGen
//
//  Created by Richard Moe on 5/12/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation


class MobFactory {
    
    static let sharedInstance = MobFactory()
    
    var monsterList : [Monster] = [Monster]()
    
    private init() {
        parseMonsterList()
    }
    
    func parseMonsterList() {
        
        let parsedCSV: [[String]] = Helper.loadFromCSV(fileName: "Monsters.csv")
        
        //Create monsterList elements:
        //Skip row one for now, unless we want to use it to lookup. Seems like too much overhead though
        
        //for each row
        // Create new monster with the appropriate string offsets which we can define by constants?
        let iName = 0
        //let Type
        //ALIGNMENT
        //Size
        //CR
        let iAC = 5
        //HP
        let iHitDice = 7
        //Spellcasting?
        //Attack 1 damage
        //Attack 2 Damage
        let iInitiative = 11
        //Hit Bonus
        //Page
        let iCR = 14
        // How do we group? Maybe buckets or use array filtering?
        for mob in parsedCSV[1...] {
            if (mob.count < iCR) {
                break
            }
            
            if let cr = Float(mob[iCR]) {
                monsterList.append(Monster(name: mob[iName], armorClass: Int(mob[iAC])!, hitPoints: 0, initiativeBonus: Int(mob[iInitiative])!, image: "Avatar4", hitDice: mob[iHitDice], challengeRating: cr)) //Float(mob[iCR])))
            }
            //init(name: String, armorClass: Int, hitPoints: Int, initiativeBonus: Int, image: String, hitDice: String, challengeRating: Double)
            
        }
    }
    
    func makeMonster(name: String) -> Monster {
        
        if let mobData = monsterList.first(where: {$0.name.lowercased() == name.lowercased()}) {
            return mobData.makeMob()
        } else {
            fatalError("Can't find mob: \(name)")
        }
    }
}
