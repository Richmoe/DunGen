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
    
    //Treasure
    
    
    private var dungeon : DungeonScene?
    
    
    
    
    var mobSprite = [SKSpriteNode]()
    
    let offset = 32
    
    
    init(at: MapPoint) {
        
        var m : Monster
        for _ in 1...4 {
            m =  MobFactory.sharedInstance.makeMonster(name: "goblin")
            mob.append(m)
            
        }
        self.at = at
    }
    
    func atPt() -> CGPoint {
        return mobSprite[0].position - getOffset(0)
    }
    
    func initMobSprites(dungeon: DungeonScene) {
        
        self.dungeon = dungeon
        for i in 0..<mob.count {
            
            
            let mobAt = Global.adventure.dungeon.currentLevel().centerPtToCGPoint(at)

            let a = mob[i].instantiateSprite(at: (mobAt + getOffset(i)))

            
            dungeon.addChild(a)

        }
    }
    
    func setAt(atPt: CGPoint, atTile: MapPoint) {
        at = atTile
        for i in 0..<mob.count {
            let pt = atPt + getOffset(i)
            mobSprite[i].position = pt
        }
        
    }
    
    func moveMob(mobIx: Int, toPt: CGPoint, toTile: MapPoint) {
        
        at = toTile
        
        
        let mv = SKAction.move(to: toPt + getOffset(mobIx), duration: 1.0 + (Double.random(in: -0.05...0.05)))
        mobSprite[mobIx].run(mv) {
            //is moving = false
        }
        
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


