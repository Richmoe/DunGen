//
//  LootFactory.swift
//  DunGen
//
//  Created by Richard Moe on 1/15/21.
//  Copyright © 2021 Richard Moe. All rights reserved.
//

import Foundation


class LootFactory {
    
    static let sharedInstance = LootFactory()
    
    typealias MagicTableEntry = (table: String, roll: Int, item: String)
    //while the data shows the magic table, we'll use Int for simplicity, e.g. table A = 0; for special rolls
    var magicTables : [MagicTableEntry] = [MagicTableEntry]()
    
    private init() {
        parseMagicList()
    }
    
    
    func parseMagicList() {
        
        let parsedCSV: [[String]] = Helper.loadFromCSV(fileName: "DGMagicTables.csv")
        
        //Assume first row is header:
        for item in parsedCSV[1...] {
            if (item.count != 3) {
                break
            }
            
            if let roll = Int(item[1]) {
                magicTables.append((item[0],roll,item[2]))
            } else {
                print ("error with item: \(item)")
            }
        }
        
        
        //test:
//        for _ in 0...10 {
//
//
//            print(" \(getMagicItem(table: "i"))")
//        }
    }
    
    func getMagicItem(table: String) -> String {
        
        
        let filteredListByTable = magicTables.filter { $0.table == table }
        
        let roll = GetDiceRoll("1d100")
        
        for i in 0..<filteredListByTable.count {
            if (roll <= filteredListByTable[i].roll) {
                let item = filteredListByTable[i].item
                
                if (item.prefix(1) == "(") {
                    let specialList = magicTables.filter { $0.table == (table + "s")}
                    let specialRoll = GetDiceRoll(item)
                    for i in 0..<specialList.count {
                        if (specialRoll <= specialList[i].roll) {
                            return specialList[i].item
                        }
                    }
                } else {
                    return filteredListByTable[i].item
                }
            }
        }
        return "Worthless Junk"
    }

    
    func getIndividualTreasure(cr: Int) -> Loot {
        
        let loot = Loot()
        
        let roll = DGRand.sharedInstance.getRand(to: 100)
        
        if (cr <= 4) {
            if (roll <= 30) {
                loot.copper = GetDiceRoll("5d6")
            } else if (roll <= 60) {
                loot.silver = GetDiceRoll("4d6")
            } else if (roll <= 70) {
                loot.electrum = GetDiceRoll("3d6")
            } else if (roll <= 95) {
                loot.gold = GetDiceRoll("3d6")
            } else {
                loot.platinum = GetDiceRoll("1d6")
            }
        } else if (cr <= 10) {
            if (roll <= 30) {
                loot.copper = GetDiceRoll("4d6") * 100
                loot.electrum = GetDiceRoll("1d6") * 10
            } else if (roll <= 60) {
                loot.silver = GetDiceRoll("6d6") * 10
                loot.gold = GetDiceRoll("2d6") * 10
            } else if (roll <= 70) {
                loot.electrum = GetDiceRoll("1d6") * 100
                loot.gold = GetDiceRoll("2d6") * 10
            } else if (roll <= 95) {
                loot.gold = GetDiceRoll("4d6") * 10
            } else {
                loot.gold = GetDiceRoll("2d6") * 10
                loot.platinum = GetDiceRoll("3d6")
            }
        } else if (cr <= 16) {
            if (roll <= 20) {
                loot.silver = GetDiceRoll("4d6") * 100
                loot.gold = GetDiceRoll("1d6") * 100
            } else if (roll <= 35) {
                loot.electrum = GetDiceRoll("1d6") * 100
                loot.gold = GetDiceRoll("1d6") * 100
            } else if (roll <= 75) {
                loot.gold = GetDiceRoll("2d6") * 100
                loot.platinum = GetDiceRoll("1d6") * 10
            } else {
                loot.gold = GetDiceRoll("2d6") * 100
                loot.platinum = GetDiceRoll("2d6") * 10
            }
        } else { //cr 17+
            if (roll <= 15) {
                loot.electrum = GetDiceRoll("2d6") * 1000
                loot.gold = GetDiceRoll("8d6") * 100
            } else if (roll <= 55) {
                loot.gold = GetDiceRoll("1d6") * 1000
                loot.platinum = GetDiceRoll("1d6") * 100
            } else {
                loot.gold = GetDiceRoll("1d6") * 1000
                loot.platinum = GetDiceRoll("2d6") * 100
            }
        }
        
        return loot
    }
    
    func getTreasureHoard(cr: Int) -> Loot {
        
        let loot = Loot()
        let roll = DGRand.sharedInstance.getRand(to: 100)
        
        if (cr <= 4) {
            loot.copper = GetDiceRoll("6d6") * 100
            loot.silver = GetDiceRoll("3d6") * 100
            loot.gold = GetDiceRoll("2d6") * 10
        } else if (cr <= 10) {
            loot.copper = GetDiceRoll("2d6") * 100
            loot.silver = GetDiceRoll("2d6") * 1000
            loot.gold = GetDiceRoll("6d6") * 100
            loot.platinum = GetDiceRoll("3d6") * 10
        } else if (cr <= 16) {
            loot.gold = GetDiceRoll("4d6") * 1000
            loot.platinum = GetDiceRoll("5d6") * 100
            
        } else { //cr 17+
            loot.gold = GetDiceRoll("12d6") * 1000
            loot.platinum = GetDiceRoll("8d6") * 1000
        }
        
        
        return loot
        
    }
}



