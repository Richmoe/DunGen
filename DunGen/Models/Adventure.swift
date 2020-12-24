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
    
    
    //Difficulty
    
    //Set up Encounters
    
    //Manage battles?
    var currentBattle: BattleController?
    @Published var inBattle = false
    
    
    var killedMobs = [String: Int]() //dictionary - Mob name/type, count
    
    @Published var totalExperience: Int = 0
    
    private var crToExpTable = Dictionary<Int, Int>()
    
    
    init() {

        
        dungeon = Dungeon()
        
        loadCrToExpTable()
        
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
        let totalExp = Int(round(mod * Double(exp)))
        print ("Total Exp: \(totalExp)")
        
        totalExperience += totalExp
    }
    
    func getExpMod(killed: Int) -> Double {
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
    
    func getExpFromCr(cr: Double) -> Int {
        
        //Convert the CR to int*100
        
        let crx100 = Int(cr * 100)
        
        if let exp = crToExpTable[crx100] {
            return exp
        } else {
            return 0
        }
    }
    
    func getCrFromExp(exp: Int) -> Double {
        
        var cr = 0.0
        var expTable = 0
        
        for (key, value) in crToExpTable {
            //print("\(key), \(value)")
            if (value > expTable && value <= exp) {
                cr = Double(key) / 100.0
                expTable = value
            }
        }
        
        
        return cr
    }
    
    func crMath(cr: Double, mod: Int) -> Double {
        
        let crTable = [0.13, 0.25, 0.5, 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0,16.0,17.0,18.0,19.0,20.0]
        
        if let ix = crTable.firstIndex(of: cr) {

            var i = ix
            i += mod
            i = max(0,min(i, crTable.count - 1))
            
            return crTable[i]

        } else {
            print("!!!!!!!!!! cr \(cr) NoT FOUND")
       
            return 0.0
        }
        
    }
    
    func loadCrToExpTable() {
        let parsedCSV: [[String]] = Helper.loadFromCSV(fileName: "crToExp.csv")
        
        let iCRx100 = 0
        //let iCRstr = 1
        let iExp = 2
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
