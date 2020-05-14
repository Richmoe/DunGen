//
//  MobFactory.swift
//  DunGen
//
//  Created by Richard Moe on 5/12/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation


class MobFactory {

    var monsterList : [Monster] = [Monster]()
    
    init() {
        
        parseMonsterList()
    }
    
    func parseMonsterList() {
        
        let content = loadFromResource(fileName: "Monsters.csv")
        
        let parsedCSV: [[String]] = content.components(separatedBy: "\n").map{ $0.components(separatedBy: ",") }
        
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
            monsterList.append(Monster(name: mob[iName], armorClass: Int(mob[iAC])!, hitPoints: 0, initiativeBonus: Int(mob[iInitiative])!, image: "Avatar4"))
        }
    }
    
    
    
    func loadFromResource(fileName: String) -> String {
        let fileContents: String
        let path = Bundle.main.path(forResource: fileName, ofType: nil)
        do {
            fileContents = try String(contentsOfFile:path!, encoding: String.Encoding.utf8)
            //                let lines = fileContents.components(separatedBy: "\n")
            //
            //                for row in 0..<lines.count {
            //                    let items = lines[row].components(separatedBy: " ")
            //                    var str = ""
            //                    for column in 0..<items.count {
            //                        str += items[column] + " "
            //                    }
            //                    print ("row: \(row): \(str)")
            //                }
        } catch {
            fatalError("Error Reading Resource \(fileName)")
        }
        return fileContents
    }
}
