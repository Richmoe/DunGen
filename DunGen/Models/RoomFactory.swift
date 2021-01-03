//
//  RoomFactory.swift
//  DunGen
//
//  Created by Richard Moe on 1/2/21.
//  Copyright © 2021 Richard Moe. All rights reserved.
//



class RoomFactory {
    
    static let sharedInstance = RoomFactory()
    
    var roomCount: Int = 0
    
    private init() {
        //parseTrapList()
        //parseDescriptionList()
    }
    
//    func parseMonsterList() {
//
//        let parsedCSV: [[String]] = Helper.loadFromCSV(fileName: "DGMonsters.csv")
//
//
//        let iName = 0
//        //let Type
//        //ALIGNMENT
//        //Size
//        //CR
//        let iAC = 5
//        //HP
//        let iHitDice = 7
//        //Spellcasting?
//        //Attack 1 damage
//        //Attack 2 Damage
//        let iInitiative = 11
//        //Hit Bonus
//        //Page
//        let iCR = 14
//        let iRarity = 15 //Rarety - 1-9 relative rarety
//        let iMotif = 16
//
//
//
//        // How do we group? Maybe buckets or use array filtering?
//        for mob in parsedCSV[1...] {
//            if (mob.count < iCR) {
//                break
//            }
//
//            if let cr = Double(mob[iCR]) {
//
//
//                if let ix = tempMotifStringArray.firstIndex(of: mob[iMotif]) {
//                    monsterList.append(Monster(name: mob[iName], armorClass: Int(mob[iAC])!, hitPoints: 0, initiativeBonus: Int(mob[iInitiative])!, image: "Avatar4", hitDice: mob[iHitDice], challengeRating: cr, rarity: Int(mob[iRarity])!, motif: ix)) //Double(mob[iCR])))
//                } else {
//                    monsterList.append(Monster(name: mob[iName], armorClass: Int(mob[iAC])!, hitPoints: 0, initiativeBonus: Int(mob[iInitiative])!, image: "Avatar4", hitDice: mob[iHitDice], challengeRating: cr, rarity: Int(mob[iRarity])!, motif: 0)) //Double(mob[iCR])))
//                }
//            }
//            //init(name: String, armorClass: Int, hitPoints: Int, initiativeBonus: Int, image: String, hitDice: String, challengeRating: Double)
//
//        }
//    }
    
    func makeRoom(at: MapPoint, width: Int = 0, height: Int = 0) -> Room {
        roomCount += 1
        
        let r = Room(at: at, w: width, h: height)
        
        return r
        
    }
    
}
