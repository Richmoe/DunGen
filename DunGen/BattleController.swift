//
//  BattleController.swift
//  DunGen
//
//  Created by Richard Moe on 5/16/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation
import SpriteKit


/* BattleController is:
 Encounter obj
 Party obj
 Initiative
 Battle order management
 
 
 */

class BattleController : ObservableObject {
    
    let encounter: Encounter
    
    let party: Party
    
    let map: Map
    
    var initiative: [(Int, Mob)] = []
    
    @Published var current = 0
    @Published var round = 1
    
    var tileMap: SKTileMapNode
    var highlightSprite : SKShapeNode?
    var targetSprite: SKSpriteNode?
    
    
    init (encounter: Encounter, map: Map, tileMap: SKTileMapNode) {
        self.encounter = encounter
        self.party = Global.adventure.party
        self.map = map
        self.tileMap = tileMap
        
        generateInitiative()
        
        createSelectionSprite()
        createTargetSprite()
        
    }
    
    func createSelectionSprite() {
        let h  = SKShapeNode(circleOfRadius: 25)
        h.name = "current"
        h.position = CGPoint(x: 0, y: 0)
        h.strokeColor = SKColor.black
        h.fillColor = SKColor.orange
        highlightSprite = h
        tileMap.addChild(h)
    }
    
    func createTargetSprite() {
        let s  = SKSpriteNode(imageNamed: "Sword2.png")
        s.name = "target"
        s.setScale(0.5)
        s.position = CGPoint(x: 0, y: 0)
        targetSprite = s
        tileMap.addChild(s)
    }
    
    func cancelEncounter() {
        
        
        //TODO - is this right here???
        //Clear the encounter from the map
        let mapAt = encounter.at
        
        let mapBlock = map.getBlock(mapAt)
        mapBlock.encounter = nil
        
        //clear the encounter sprites
        encounter.removeMapSprites()
        

        //Swtich back UI
        Global.dungeonScene!.endBattle()
        

    
    }
    
    func endEncounter() {
        
        //We will leave the encounter but make it a Dead state
        //TODO: Add dead state
        
    }
    
    //wherein I figure out what to do with where I clicked:
    func clickAt(_ clickPt: CGPoint) {
        
        //Todo: we should probably figure out intent on click but for now we just move
        if (Global.isMoving) {
            return
        }
        
        
        //Check click on  mobs
        if let mob = getMobAtPt(clickPt) {
            print ("ClickedMob: \(mob.name)")
            //
            clickedMob(mob)
            
        } else {
            
            moveCurrent(clickPt)
        }
    }
    
    func clickedMob(_ mob: Mob) {
        
        //Check if player or monster
        if mob is Player {
            print("clickd Player")
            //get current IX:
            for i in 0..<initiative.count {
                let (_, player) = initiative[i]
                if (player === mob) {
                    current = i
                    break
                }
            }
        } else {
            print("clicked Monster")
            setCurrentsTarget(mob)
        }
    }
    
    func setCurrentsTarget(_ mob: Mob) {
        
        let (_, m) = initiative[current]
        m.currentTarget = mob
        
    }
    
    func getMobAtPt(_ clickPt: CGPoint) -> Mob? {
    
        return getMobAtMap(map.CGPointToBattleMapPoint(clickPt))

    }
    
    func getMobAtMap(_ mapPt: MapPoint) -> Mob? {
        var clicked : Mob?
        for (_, m) in initiative {
            if (map.CGPointToBattleMapPoint(m.at()) == mapPt) {
                clicked = m
                break
            }
        }
        
        return clicked
    }
    
    func moveCurrent(_ clickPt: CGPoint) {
        
        let toBMap = map.CGPointToBattleMapPoint(clickPt)
        let toMap = map.CGPointToMapPoint(clickPt)
        
        let (_, currentMob) = initiative[current]
        
        let mobBMapAt = map.CGPointToBattleMapPoint(currentAt())
        let mobAt = map.CGPointToMapPoint(currentAt())
        
        if (mobBMapAt == toBMap) {
            print ("Same!!!")
            return
        }
        
        
        print("MP \(mobAt) TO CG: \(map.MapPointToCGPoint(mobAt))")
        print("Battle \(mobBMapAt) to CG: \(map.BattleMapPointToCGPoint(mobBMapAt))")
        
        let direction = angleToCardinalDir(angleBetween(fromMap: mobBMapAt, toMap: toBMap))
        
        let moveVector = getCardinalMoveVector(dir: direction)
        let stepMove = mobBMapAt + moveVector
        let mapMove = mobAt + moveVector
        
        if let mob = getMobAtMap(stepMove) {
            print("can't move, colliding with mob: \(mob.name)")
            return
        }
        
        if (mobAt == toMap || map.canEnter(toPt: mapMove, moveDir: direction)) {
            
            //Do the move
            let movePt = map.BattleMapPointCenterToCGPoint(stepMove)
            
            currentMob.move(toPt: movePt)
        }
    }
    
    func generateInitiative() {
        
        var temp : [(Int, Mob)] = []
        //Roll for party
        for p in party.player {
            
            var roll = GetDiceRoll("1d20")
            roll += p.initiativeBonus
            
            temp.append((roll, p))
            
        }
        
        
        //Roll for Encounter mobs
        for m in encounter.mob {
            var roll = GetDiceRoll("1d20")
            
            roll += m.initiativeBonus
            
            temp.append((roll, m))
        }
        
        //Sort descending
        initiative = temp.sorted { $0.0 > $1.0}
    }
    
    func currentAt() -> CGPoint {
        
        let (_, m) = initiative[current]
        return m.at()
    }
    
    func currentTargetAt() -> CGPoint? {
        
        let (_, m) = initiative[current]
        
        if let target = m.currentTarget {
            return target.at()
        } else {
            return nil
        }
    }
    
    func nextTurn() {
        current += 1
        current = current % initiative.count
    }
    
    func nextRound() {
        round += 1
        current = 0
    }
}
