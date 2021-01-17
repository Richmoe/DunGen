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
    var gem : [String] = []
    
    
    //
    func random() {
        gold = GetDiceRoll("1d4")
        silver = GetDiceRoll("1d8")
        copper = GetDiceRoll("2d12")
        
    }
}
