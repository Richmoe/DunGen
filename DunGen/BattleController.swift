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
    
    var initiativeRolls: [Int] = []
    var initiativeMobs: [Mob] = []
    
    @Published var current = 0
    @Published var round = 1
    @Published var currentTargetIx = -1
    @Published var battleOver = 0 //Set this to 1 if we killed all mobs or -1 for all players
    
    var tileMap: SKTileMapNode
    var highlightSprite : SKShapeNode?
    var targetSprite: SKSpriteNode?
    

    
    
    init (encounter: Encounter, map: Map, tileMap: SKTileMapNode) {
        self.encounter = encounter
        self.party = Global.party
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
        h.fillColor = Global.selectionColor[0]
        h.zPosition = Global.zPosSelection
        h.alpha = 0.5
        highlightSprite = h
        tileMap.addChild(h)
    }
    
    func createTargetSprite() {
        let s  = SKSpriteNode(imageNamed: "Sword2.png")
        s.name = "target"
        s.setScale(0.5)
        s.position = CGPoint(x: 0, y: 0)
        s.zPosition = Global.zPosTarget
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
        
        //now what?

        encounter.endEncounter()
        
        
        Global.dungeonScene!.endBattle()
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
            if (mob.tombstoned) {
                moveCurrent(clickPt)
            } else {
                clickedMob(mob)
            }
        } else {
            
            moveCurrent(clickPt)
        }
    }
    
    func clickedMob(_ mob: Mob) {
        
        //Check if player or monster
        //if mob is Player {

//            //print("clickd Player")
//            //get current IX:
//            for i in 0..<initiativeMobs.count {
//                let player = initiativeMobs[i]
//                if (player === mob) {
//                    current = i
//                    getCurrentsTargetIx()
//                    break
//                }
//            }
//        } else {
//            //print("clicked Monster")
        if (initiativeMobs[current].tombstoned != true) {
            
            setCurrentsTarget(mob)
        }
        //}
    }
    
    func setCurrentsTarget(_ mob: Mob) {
        
        let m = initiativeMobs[current]
        m.currentTarget = mob
        
        getCurrentsTargetIx()
    }
    
    func getCurrentsTargetIx() {
        
        let m = initiativeMobs[current]
        let mob = m.currentTarget
        
        if (mob != nil) {
            
            //find mob in initiative list:
            for i in 0..<initiativeMobs.count {
                let mm = initiativeMobs[i]
                
                //if (mm.uid == mob!.uid) {
                if (mm === mob) {
                    print ("Current target found, ix: \(i)")
                    currentTargetIx = i
                    return
                }
                
            }
            
            //error
            fatalError()
        } else {
            if let mm = mob {
                print("no target for mob: \(mm.name)")
            }
            currentTargetIx = -1
        }
    }
    
    func getMobAtPt(_ clickPt: CGPoint) -> Mob? {
        
        return getMobAtMap(map.CGPointToBattleMapPoint(clickPt))
        
    }
    
    func getMobAtMap(_ mapPt: MapPoint) -> Mob? {
        var clicked : Mob?
        for m in initiativeMobs {
            if (map.CGPointToBattleMapPoint(m.at()) == mapPt) {
                clicked = m
                break
            }
        }
        
        return clicked
    }
    
    func moveCurrent(_ clickPt: CGPoint) {
        
        let currentMob = initiativeMobs[current]
        if (currentMob.tombstoned) {
            return
        }
        
        let toBMap = map.CGPointToBattleMapPoint(clickPt)
        let toMap = map.CGPointToMapPoint(clickPt)
        

        
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
            if (!mob.tombstoned) {
                print("can't move, colliding with mob: \(mob.name)")
                return
            }
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
        temp = temp.sorted { $0.0 > $1.0}
        
        for t in temp {
            initiativeRolls.append(t.0)
            initiativeMobs.append(t.1)
        }
    }
    
    func currentAt() -> CGPoint {
        
        let m = initiativeMobs[current]
        return m.at()
    }
    
    func currentTargetAt() -> CGPoint? {
        
        let m = initiativeMobs[current]
        
        if let target = m.currentTarget {
            return target.at()
        } else {
            return nil
        }
    }
    
    func setCurrent(ix: Int) {
        current = ix
        getCurrentsTargetIx()
        if let h = highlightSprite {
            
            h.fillColor = Global.selectionColor[current]
        }
        
        //also check end of battle so we can update the button:
        checkEndOfBattle()
    }
    
    func nextTurn() {
        //Note: add a counter to prevent infinite loop in case someone is being cute:
        var maxRepeat = initiativeMobs.count
        repeat {
            current += 1
            
            current = current % initiativeMobs.count
            maxRepeat -= 1
            setCurrent(ix: current)
        }  while initiativeMobs[current].tombstoned && maxRepeat > 0
        

    }
    
    func nextRound() {
        
        checkEndOfBattle()
        
        if (battleOver == 0) {
            round += 1
            current = -1 //set to negative one as nextTurn adds one to correctly start at 0, but will skip if 0 is dead.
            nextTurn()
            
            //setCurrent(ix: 0)
        } else {
            endEncounter()
        }

    }
    
    func checkEndOfBattle() {
        var deadMobs = 0
        var deadPlayers = 0
        for m in initiativeMobs {
            if (m.tombstoned) {
                if m is Monster {
                    //print ("Dead Monster")
                    deadMobs += 1
                } else {
                    //print ("Ded Plyr")
                    deadPlayers += 1
                }
            }
        }
        
        
        if (encounter.mob.count == deadMobs) {
            //print("All Mobs DEAD!")
            battleOver = 1
        }
        
        //Don't make this mutually exclusive in case someone's trying to break things. Err on wiping out party:
        if (party.player.count == deadPlayers) {
            //print("All players dead!!?!")
            battleOver = -1
        }
        
        
    }
    
}
