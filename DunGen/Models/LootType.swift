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
    
    func toString() -> String {
        
        var str = ""
        
        if (platinum > 0) {
            str += "\(platinum) PP\r\n"
        }
        if (gold > 0) {
            str += "\(gold) GP\r\n"
        }
        if (electrum > 0) {
            str += "\(electrum) EP\r\n"
        }
        if (silver > 0) {
            str += "\(silver) SP\r\n"
        }
        if (copper > 0) {
            str += "\(copper) CP\r\n"
        }
        
        let gems = getGemOrArtReadout()
        for g in gems {
            str += "\(g)\r\n"
        }
        
        let magic = getMagicReadout()
        for m in magic {
            str += "\(m)\r\n"
        }
        
        if (str.count == 0) {
            let r = DGRand.getRand(15)
            switch r {
            case 0:
                str = "Nothing of value"
            case 1:
                str = "Worthless trinkets"
            case 2:
                str = "Moldy cheese"
            case 3:
                str = "Stale bread"
            case 4:
                str = "Rotting clothing"
            case 5:
                str = "A scrap of rusty armor"
            case 6:
                str = "A broken dagger"
            case 7:
                str = "Garbage"
            case 8:
                str = "A half-eaten mouse"
            default:
                str = "Nothing"
            }
        }
        
        
        return str
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
