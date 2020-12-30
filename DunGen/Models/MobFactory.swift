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
    
    //NOTE: there are no monsters at CR 19 in the table, so I'm going to special case requests for CR: 19 as a CR: 18 request
    
    
    
    //This is going to be a filtered monster list by Motif for now. This would mean any time I change motif, I'd need to rebuild MobFactory
    // So therefore I need to evaluate instantiation pipeline, e.g. for each new Adventure, rebuild the mob factory?
    var monsterList : [Monster] = [Monster]()
    
    private init() {
        parseMonsterList()
    }
    
    func parseMonsterList() {
        
        let parsedCSV: [[String]] = Helper.loadFromCSV(fileName: "DGMonsters.csv")
        
        //Create monsterList elements:
        //Skip row one for now, unless we want to use it to lookup. Seems like too much overhead though
        
        //for each row
        // Create new monster with the appropriate string offsets which we can define by constants?
        //0 Name,Type,ALIGNMENT,Size,CR,
        //5 AC,HP,HitDice,Spellcasting?,Attack 1 damage,
        //10 Attack 2 Damage,Initiative,Hit Bonus,Page,CR (Decimal),
        //15 Rarety,Motif,Arctic,Coast,Desert,
        //20 Forest,Grassland,Hill,Mountain,Swamp,
        //25 Underdark,Urban,Book
        
        
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
        let iRarity = 15 //Rarety - 1-9 relative rarety
        let iMotif = 16
        
        
        //This is a quick hack to convert strings in CSV to Int, which matches the consts in Adventure:motif; index =sames as adventure motif constants
        let tempMotifStringArray =
        ["Basic",
        "Cavern",
        "Crypt",
        "Dungeon",
        "Exotic",
        "Magic"]
        /*
         is a String representing a TYPE of dungeon
         - Basic
         - Cavern
         - Crypt
         - Dungeon
         - Exotic
         - Magic

         */
        
        // How do we group? Maybe buckets or use array filtering?
        for mob in parsedCSV[1...] {
            if (mob.count < iCR) {
                break
            }
            
            if let cr = Double(mob[iCR]) {
                
                if let ix = tempMotifStringArray.firstIndex(of: mob[iMotif]) {
                    monsterList.append(Monster(name: mob[iName], armorClass: Int(mob[iAC])!, hitPoints: 0, initiativeBonus: Int(mob[iInitiative])!, image: "Avatar4", hitDice: mob[iHitDice], challengeRating: cr, rarity: Int(mob[iRarity])!, motif: ix)) //Double(mob[iCR])))
                } else {
                    monsterList.append(Monster(name: mob[iName], armorClass: Int(mob[iAC])!, hitPoints: 0, initiativeBonus: Int(mob[iInitiative])!, image: "Avatar4", hitDice: mob[iHitDice], challengeRating: cr, rarity: Int(mob[iRarity])!, motif: 0)) //Double(mob[iCR])))
                }
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
    
    func getMobBy(cr: Double) -> Monster {
        
        
        let filteredMobsByMotif = monsterList.filter { $0.motif == 0 || $0.motif == Global.adventure.motif }
        
        
        
        //So I will try maxLoop times to find a monster at the given CR level. If I don't, then I'll step down one CR and try maxloop more times, to a max of stepdown CRs.
        var stepDown = 6 //max number of CRs to step down if I don't find a match
        var mob : Monster?
        var curCR = cr
        
        //print ("getMobBy(cr: \(cr)")
        repeat {

            var maxLoop = 5 //max number of tries to get a mob match
            let filteredMobsByCR = filteredMobsByMotif.filter { $0.challengeRating == curCR }

            
            while (maxLoop > 0 && filteredMobsByCR.count > 0) {
                let mobIX = DGRand.getRandRand(filteredMobsByCR.count)
                mob = filteredMobsByCR[mobIX - 1]
                
                //Do a rarity check - for now, just a simple 1-10 roll; if roll > rarity than it sticks:
                // TODO: Need to do a better rarity check
                
                let rand = DGRand.getRandRand(10) - 1
                if (rand >= mob!.rarity) {
                    maxLoop = -1 //exit flag
                    stepDown = -1
                    
                    //print ("Found mob: \(mob!.name) CR: \(mob!.challengeRating) with rarity: \(mob!.rarity)")
                } else {
                    maxLoop -= 1
                }
            }
            
            if (curCR >= 2.0) {
                curCR -= 1.0
            } else {
                if (curCR > 0) {
                    curCR /= 2.0
                }
            }
            stepDown -= 1
            

        } while (stepDown > 0)
        
        
        return mob!
    }
}
