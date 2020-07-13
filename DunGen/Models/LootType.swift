//
//  LootType.swift
//  DunGen
//
//  Created by Richard Moe on 7/12/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation


class Loot {
    var treasurePlatinum = 0
    var treasureGold = 0
    var treasureElectrum = 0
    var treasureSilver = 0
    var treasureCopper = 0
    
    var treasureMisc : [String] = []
    var treasureMagic: [String] = []
    
    
    //
    func random() {
        treasureGold = GetDiceRoll("1d4")
        treasureSilver = GetDiceRoll("1d8")
        treasureCopper = GetDiceRoll("2d12")
        
    }
}
