//
//  EncounterModel.swift
//  DunGen
//
//  Created by Richard Moe on 5/14/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation
import SpriteKit

class Encounter {
    
    //Encounter is a generated list of monsters, their location, and their treasure
    
    
    
    //list of mobs
    @Published var mob = [Monster]()
    
    // Map location
    @Published var at = MapPoint(row: 0, col: 0)
    
//    let STATE_ACTIVE = 0
//    let STATE_CLEARED = 1
    var stateActive = true
    
    //Treasure
//    var treasurePlatinum = 0
//    var treasureGold = 0
//    var treasureElectrum = 0
//    var treasureSilver = 0
//    var treasureCopper = 0
//
//    var treasureOther: String = ""
    
    //Loot is maybe a new struct?
    //array of Loot?
    var loot = [Loot]()
    
    
    
    
    
    
    let offset = 32
    
    
    init(at: MapPoint) {
        
        var m : Monster
        for _ in 1...4 {
            m =  MobFactory.sharedInstance.makeMonster(name: "goblin")
            mob.append(m)
            let l = Loot()
                l.random()
            loot.append(l)
        }
        self.at = at
    }
    
    
    func initMobSprites(node: SKTileMapNode) {
        
        for i in 0..<mob.count {
            
            
            let mobAt = Global.adventure.dungeon.currentLevel().MapPointCenterToCGPoint(at)
            
            let a = mob[i].instantiateSprite(at: (mobAt + getOffset(i)))
            
            
            node.addChild(a)
            
        }
    }
    
    func removeMapSprites() {
        
        for i in 0..<mob.count {
            if let s = mob[i].sprite {
                s.removeFromParent()
            }
        }
    }
    
    func endEncounter() {
        
        stateActive = false
        //transfer mobs to drops
        
        for i in 0..<mob.count {
            if (mob[i].tombstoned) {
                //convert to drop
                let d = Drop(type: 1, name: "Dead Goblin", loot: loot[i])
                d.instantiateSprite(at: mob[i].at())
                if let ds = Global.dungeonScene {
                    if let mc = ds.mapController {
                        mc.addDrop(drop: d, at: mob[i].at())
                    }
                }
            }
    
        }
            
        removeMapSprites()
        
    }
    
    
    func getOffset(_ ix: Int) -> CGPoint {
        var off: CGPoint
        switch ix {
        case 0:
            off = CGPoint(x: -offset, y: -offset)
        case 1:
            off = CGPoint(x: +offset, y: -offset)
        case 2:
            off = CGPoint(x: -offset, y: +offset)
        case 3:
            off = CGPoint(x: +offset, y: +offset)
        default:
            off = CGPoint(x: 0, y: 0)
        }
        
        return off
    }
}


