//
//  LootType.swift
//  DunGen
//
//  Created by Richard Moe on 7/12/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation


class Loot {
    var platinum = 0
    var gold = 0
    var electrum = 0
    var silver = 0
    var copper = 0
    
    var misc : [String] = []
    var magic : [String] = []
    var gemOrArt : [String] = []
    
    
    //
    func random() {
        gold = GetDiceRoll("1d4")
        silver = GetDiceRoll("1d8")
        copper = GetDiceRoll("2d12")
        
    }
    
    func addLoot(_ loot: Loot) {
        
        platinum += loot.platinum
        gold += loot.gold
        electrum += loot.electrum
        silver += loot.silver
        copper += loot.copper
        
        for mi in loot.misc {
            misc.append(mi)
        }
        
        for ma in loot.magic {
            magic.append(ma)
        }
        
        for ga in loot.gemOrArt {
            gemOrArt.append(ga)
        }
    }
    
    func printDebug() {
        print("P: \(platinum), G: \(gold), E: \(electrum), S: \(silver), C: \(copper)")
        var tempString = "MISC: "
        
        for item in misc {
            tempString += "\(item), "
        }
        print(tempString)
        
        tempString = "MAGIC: "
        for item in magic {
            tempString += "\(item), "
        }
        print(tempString)
        
        tempString = "GEM/ART: "
        for item in gemOrArt {
            tempString += "\(item), "
        }
        print(tempString)
    }
    
    func getMagicReadout() -> [String] {

        /*var str = ""
        let magicAgg = Helper.aggregateStringArray(array: magic)
        if (magicAgg.count > 0) {
            str = magicAgg[0]
            for i in 1..<magicAgg.count {
                str += "/r/n" + magicAgg[i]
            }
        }
        */

        return Helper.aggregateStringArray(array: magic, usePlural: false)
        
    }
    
    func getGemOrArtReadout() -> [String] {
        return Helper.aggregateStringArray(array: gemOrArt, usePlural: false)
    }
}
