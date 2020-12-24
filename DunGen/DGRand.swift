//
//  MapGenRand.swift
//  AdventureDungeon
//
//  Created by Richard Moe on 4/26/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import GameKit

// The Mersenne Twister is a very good algorithm for generating random
// numbers, plus you can give it a seed...

class DGRand {
    
    static let sharedInstance = DGRand()

    let rs = GKMersenneTwisterRandomSource()
    var rd : GKRandomDistribution
    
    static func getRand(_ to: Int) -> Int {
        return sharedInstance.getRand(to: to)
    }
    
    static func getRandRand(_ to: Int) -> Int {
        return sharedInstance.getRandRand(to: to)
    }
    
    
    
    private init () {
        rs.seed = 123456789
        self.rd = GKRandomDistribution(randomSource: rs, lowestValue: 1, highestValue: 1000)
    }
    func setSeed (seedString: String) {
        
        //try this is a start
        var temp = 67
        var seed = 0
        for c in seedString {
            if let yy = c.asciiValue  {
               let z = Int(yy) * Int(temp)
                temp *= 67
                seed += z
                
            }
        }

        rs.seed = UInt64(seed)
        
        self.rd = GKRandomDistribution(randomSource: rs, lowestValue: 1, highestValue: 1000)
    }

    func getRand(to: Int) -> Int {
        
        let nextNum = rd.nextInt()
        
        //range
        let range = 1000 / to

        return min(nextNum / range + 1, to)
    }
    
    func getRandRand(to: Int) -> Int {
    
        let rand = Int.random(in: 1...to)
        
        return rand
    }
    
    func shuffle(array: [Any]) -> [Any] {
        var shufArr = array
        
        //Walk through each element and swap it with a random element
        for i in 0..<shufArr.count {
            let temp = shufArr[i]
            let r = getRand(to: shufArr.count)
            shufArr[i] = shufArr[r - 1]
            shufArr[r - 1] = temp
        }
        
        return shufArr
    }
    
    static func getSeedString() -> String {
        let letters = "ABCDEFGHJLMNPQRTUVWXYZ346789"

        return String((0...3).map{ _ in letters.randomElement()! })
    }
    
}



func GetDiceRoll (_ dice: String) -> Int {

    let pattern = "(?<dCount>[0-9]*)\\s*[D]\\s*(?<die>[0-9]+)\\s*(?<op>[//+//-]*)\\s*(?<mod>[0-9]*)"
    
    let regex = try? NSRegularExpression(
        pattern: pattern,
        options: .caseInsensitive
    )
    

    var dCount: Int = 1
    var die: Int = 0
    var op: String = "+"
    var mod: Int = 0
    
    if let match = regex?.firstMatch(in: dice, options: [], range: NSRange(location: 0, length: dice.utf16.count)) {
        if let r = Range(match.range(withName: "dCount"), in: dice) {
            if let m = Int(String(dice[r])) {
                dCount = m
            }
        }
        if let r = Range(match.range(withName: "die"), in: dice) {
            die = Int(String(dice[r]))!
        }
        if let r = Range(match.range(withName: "op"), in: dice) {
            let str = String(dice[r])
            if (str.count > 0) {
                op = str
            }
        }
        if let r = Range(match.range(withName: "mod"), in: dice) {
            if let m = Int(String(dice[r])) {
                mod = m
            }
        }
    }
    
    var roll =  0
    for _ in 1...dCount {
        roll += Int.random(in: 1...die)
    }
    
    if (op == "-") {
        roll -= mod
    } else {
        roll += mod
    }

    return roll
}

