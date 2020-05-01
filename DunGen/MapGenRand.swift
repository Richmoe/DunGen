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

class MapGenRand {
    
    static let sharedInstance = MapGenRand()

    let rs = GKMersenneTwisterRandomSource()
    var rd : GKRandomDistribution
    
    
    
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


