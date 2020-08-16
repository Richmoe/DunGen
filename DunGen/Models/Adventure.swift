//
//  Adventure.swift
//  DunGen
//
//  Created by Richard Moe on 5/15/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation

class Adventure : ObservableObject {
    
    //Map
    var dungeon: Dungeon
    
    //Party
    var party : Party
    
    //Difficulty
    
    //Set up Encounters
    
    //Manage battles?
    var currentBattle: BattleController?
    @Published var inBattle = false
    
    
    var killedMobs = [String: Int]() //dictionary - Mob name/type, count
    
    @Published var totalExperience: Int = 0
    
    private var crToExpTable = Dictionary<Int, Int>()
    
    
    init() {
        party = Party()
        
        dungeon = Dungeon()
        
        loadCrToExpTable()
        
    }
    
    func createPlayers() {
        
        var p1 = Player(name: "Cherrydale", level: 1, experience: 0, armorClass: 6, hitPoints: 8, initiativeBonus: 2, avatar: "Avatar1")
        party.addPlayer(p1)
        
        p1 = Player(name: "Tomalot", level: 1, experience: 0, armorClass: 6, hitPoints: 8, initiativeBonus: 2, avatar: "Avatar2")
        party.addPlayer(p1)
        
        p1 = Player(name: "Svenwolf", level: 1, experience: 0, armorClass: 6, hitPoints: 8, initiativeBonus: 2, avatar: "Avatar3")
        party.addPlayer(p1)
        
        p1 = Player(name: "Sookie", level: 1, experience: 0, armorClass: 6, hitPoints: 8, initiativeBonus: 2, avatar: "Avatar4")
        party.addPlayer(p1)
        
    }
    
    func calcEncounter(encounter: Encounter) {
        
        
        var exp = 0
        var killCount = 0
        
        for m in encounter.mob {
            
            if (m.tombstoned == true) {
                if let k = killedMobs[m.name] {
                    killedMobs[m.name] = k + 1
                } else {
                    killedMobs[m.name] = 1
                }
                killCount += 1
                exp += getExpFromCr(cr: m.challengeRating)
            }
        }
        
        //Calc exp modifier by # of mobs killed
        let mod = getExpMod(killed: killCount)
        let totalExp = Int(round(mod * Float(exp)))
        print ("Total Exp: \(totalExp)")
        
        totalExperience += totalExp
    }
    
    func getExpMod(killed: Int) -> Float {
        //Diff multiplier
        if (killed <= 0) {
            return 0.0
        } else if (killed == 1) {
            return 1.0
        } else if (killed == 2) {
            return 1.5
        } else if (killed <= 6) {
            return 2.0
        } else if (killed <= 10) {
            return 2.5
        } else if (killed <= 14) {
            return 3.0
        } else { //15+
            return 4.0
        }
    }
    
    func getExpFromCr(cr: Float) -> Int {
        
        //Convert the CR to int*100
        
        let crx100 = Int(cr * 100)
        
        if let exp = crToExpTable[crx100] {
            return exp
        } else {
            return 0
        }
    }
    
    func loadCrToExpTable() {
        let parsedCSV: [[String]] = Helper.loadFromCSV(fileName: "crToExp.csv")
        
        let iCRx100 = 0
        //let iCRstr = 1
        let iExp = 2
        crToExpTable[99] = 990
        for val in parsedCSV[1...] {
            if (val.count < iExp) {
                break
            }
            
            if  let ik = Int(val[iCRx100]) {
                
                if let iv = Int(val[iExp]) {
                    crToExpTable[ik] = iv
                }

            }
        }
    }
}
