//
//  MapController.swift
//  DunGen
//
//  Created by Richard Moe on 5/7/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation
import SpriteKit


class MapController {
    
    var dungeon : Dungeon
    
    var tileMap: SKTileMapNode
    
    var targetSprite: SKSpriteNode?
    
    var dropQueue = [Drop]()
    
    init(dungeon: Dungeon, tileMap: SKTileMapNode) {
        
        self.dungeon = dungeon
        
        self.tileMap = tileMap
        createTargetSprite()
    }
    
    func addDrop(drop: Drop) {
        
        
        //add to drop queue
        dropQueue.append(drop)
        
        
        // Add to map:
        if let s = drop.sprite {
            tileMap.addChild(s)
        }
        
    }
    
    
    func clickAt(_ clickPt: CGPoint) {
        
        if (Global.isMoving) {
            return
        }
        
        
        //Check the grid we clicked on. If self, ignore
        let clickSpot = dungeon.currentLevel().CGPointToMapPoint(clickPt)
        
        //Figure out if anything is there:
        let block = dungeon.currentLevel().getBlock(clickSpot)
        
        if let e = block.encounter {
            //print("Encounter!?!")
            
            if (e.stateActive == true) {
                //                //check to see if we clicked a tombstone?
                //                print ("Clicked encounter, not active")
                //
                //                let sprites = tileMap.nodes(at: clickPt)
                //
                //                print ("Sprites: \(sprites)")
                //                return
                //            }
                
                if let t = targetSprite {
                    
                    let tempPos = dungeon.currentLevel().MapPointCenterToCGPoint(clickSpot)
                    if (tempPos == t.position) {
                        //print ("Second click - Battle Trigger!!!")
                        if let d = Global.dungeonScene {
                            d.initBattle(encounter: e)
                            targetSpriteAt(MAP_POINT_NULL)
                        }
                    } else {
                        //print ("First click on encounter")
                        Global.adventure.currentStatus = e.toString()
                        targetSpriteAt(clickSpot)
                    }
                }
                return
            }
        }
        
        //Perhaps we add to a queue of encounters when we trigger it?
        
        //In mapbattle, when we click on a sprite, we walk all encounters to see which mob it is?
        // This seems highly odd but I'm going for it. Likely need to refactor
        
        //Actually we need a similar logic for chests, traps, etc. what did we actually click on?
        //Maybe killing a mob drops a tombstone in the block. A block can have multiple "things" - trap, tombstone, treasure chest
        
        //If the clickspot is adjacent to the player, then we check to see if they clicked on something, otherwise we move towards that spot. e.g. if the tombstone is 2 squares away we don't care we clikced on the tombstone, we just move towards it. Only check to see if we clicked on a tombstone if its next to us.
        
        let deltaClick = clickSpot - Global.party.at
        
        if (abs(deltaClick.col) == 1 || abs(deltaClick.row) == 1) {
            
            
            let sprites = tileMap.nodes(at: clickPt)
            if (sprites.count > 0) {
                
                print ("We clicked a sprite!!! \(sprites[0].name ?? "null")")
                //find if it's a drop
                for i in 0..<dropQueue.count {
                    if (sprites[0] == dropQueue[i].sprite) {
                        print ("Clicked a drop!!")
                        Global.adventure.getLoot(dropQueue[i].getLoot())
                        dropQueue[i].sprite?.removeFromParent()
                        dropQueue.remove(at: i)
                        return
                    }
                }
                
            }
            
        }
        
        
        targetSpriteAt(MAP_POINT_NULL)
        moveTo(clickSpot)
        
    }
    
    func moveTo(_ toMap: MapPoint) {
        
        if (toMap == Global.party.at) {
            //print("SAME!!!")
            return
        }
        
        
        let direction = angleToCardinalDir(angleBetween(fromMap: Global.party.at, toMap: toMap))
        
        let moveVector = getCardinalMoveVector(dir: direction)
        let stepMove = Global.party.at + moveVector
        
        if (dungeon.canEnter(toPt: stepMove, moveDir: direction)) {
            
            //Do the move
            let movePt = dungeon.currentLevel().MapPointCenterToCGPoint(stepMove)
            
            Global.party.moveParty(toPt: movePt, toTile: MapPoint(row: stepMove.row, col: stepMove.col))
            //just in case:
            renderTile(stepMove)
            
            //Temp:
            revealSecretDoor(at: stepMove)
            unlockDoor(at: stepMove)
            
            fogOfWar()
        }
        
    }
    
    func placeParty() {
        goToTile(dungeon.getPlayerEntrance())
        fogOfWar()
    }
    
    
    func createTargetSprite() {
        let s  = SKSpriteNode(imageNamed: "Sword2.png")
        s.name = "maptarget"
        s.setScale(1.5)
        s.position = CGPoint(x: 0, y: 0)
        s.zPosition = Global.zPosTarget
        targetSprite = s
        tileMap.addChild(s)
    }
    
    func targetSpriteAt(_ pt: MapPoint) {
        
        if let t = targetSprite {
            
            if (pt == MAP_POINT_NULL) {
                t.isHidden = true
                t.position = CGPoint(x: 0, y: 0)
            } else {
                t.isHidden = false
                t.position = dungeon.currentLevel().MapPointCenterToCGPoint(pt)
            }
        }
    }
    
    func goToTile(_ tile: MapPoint) {
        let movePt = tileMap.centerOfTile(atColumn: tile.col, row: tile.row)
        
        Global.party.setAt(atPt: movePt, atTile: MapPoint(row: tile.row, col: tile.col))
        
        renderTile(tile)
    }
    
    
    func revealSpot(_ mp: MapPoint) {
        
        //check to see if we've placed the tile already, or just ignore?
        if tileMap.tileGroup(atColumn: mp.col, row: mp.row) == nil {
            //print ("Reveal: \(mp)")
            renderTile(mp)
            //check to see if we have an encounter:
            
            let mb = dungeon.getBlock(mp)
            if let e = mb.encounter {
                //trigger encounter
                print("Encounter!!!")
                e.initMobSprites(node: tileMap)
            }
            
            if let t = mb.treasure {
                print("Treasure")
                let s = t.instantiateSprite(at: dungeon.currentLevel().MapPointCenterToCGPoint(mp))
                addDrop(drop: t)
            }
//            else {
//                //test
//                let tempPos = dungeon.currentLevel().MapPointCenterToCGPoint(mp)
//                let d = Drop(type: 2,name: "Treasure", loot: Loot())
//                d.instantiateSprite(at: tempPos)
//                addDrop(drop: d, at: tempPos)
//            }
        }
        
    }
    
    func renderTile(_ mp: MapPoint) {
        
        renderTile(layer: tileMap, mp: mp)
    }
    
    func renderTile(layer: SKTileMapNode, mp: MapPoint) {
        
        let mb = dungeon.getBlock(mp)
        if let groupIx = Global.mapTileSet.tileDict[mb.wallString] {
            //print ("rendering tile \(tile.wallString): \(groupIx) at c/R: \(col), \(row)")
            layer.setTileGroup(layer.tileSet.tileGroups[groupIx], forColumn: mp.col, row: mp.row)
        } else {
            if (mb.wallString != "0000") {
                print ("Can't find tile: \(mb.wallString) at rc: \(mp.row), \(mp.col)")
            }
        }
    }
    
    func renderTile(layer: SKTileMapNode, code: String, mp: MapPoint) {
        
        if let groupIx = Global.mapTileSet.tileDict[code] {
            //print ("rendering tile \(tile.wallString): \(groupIx) at c/R: \(col), \(row)")
            layer.setTileGroup(layer.tileSet.tileGroups[groupIx], forColumn: mp.col, row: mp.row)
        } else {
            
            print ("Can't find tile: \(code) at rc: \(mp.row), \(mp.col)")
            
        }
    }
    
    func renderDebugMap(layer: SKTileMapNode, overlay: SKTileMapNode) {
        
        for row in 0..<Global.adventure.dungeon.mapHeight {
            for col in 0..<Global.adventure.dungeon.mapWidth {
                
                //map base
                renderTile(layer: layer, mp: MapPoint(row: row, col: col))
                
                
                //Debug overlay
                let tileBlock = (dungeon.getBlock(MapPoint(row: row, col: col)))
                
                if tileBlock.encounter != nil {
                    renderTile(layer: overlay, code: "DEBUG_ROOM", mp: MapPoint(row: row, col: col))
                    
                }
                
                //Secret wall override:
                if (tileBlock.wallString.contains("S")) {
                    renderTile(layer: overlay, code: "Sxxx", mp: MapPoint(row: row, col: col))
                    
                }
                
            }
        }
    }
    
    
    func fogOfWar() {
        //input new position
        
        for a in 0...59 { //6deg increments
            let ang = 6 * Double(a)
            let x = sin(ang  * (.pi / 180))
            let y = cos(ang * (.pi / 180))
            var fromPt = Global.party.at
            var lastXx = 0
            var lastYy = 0
            
            for i in 1...Global.maxLineOfSight {
                let xx = Int(round(x * Double(i)))
                let yy = Int(round(y * Double(i)))
                if (xx != 0 || yy != 0) {
                    
                    let moveVector = MapPoint(row: yy - lastYy, col: xx - lastXx)
                    
                    lastXx = xx
                    lastYy = yy
                    
                    let toPt = fromPt + moveVector
                    
                    if (canSee(from: fromPt, to: toPt)) {
                        //Yes there are multiple renders of the same thing. Is this slower? I should benchmark
                        revealSpot(toPt)
                        //renderTile(toPt)
                        fromPt = toPt
                    } else {
                        break
                    }
                }
            }
        }
    }
    
    func unlockDoor(at: MapPoint) {
        //get wall that has S
        let mapBlock = dungeon.getBlock(at)
        //perhaps we could pass in direction, as this would not work with > 1 secret door but I don't think that's a big concern:
        for dir in [Direction.north, .south, .east, .west] {
            let p = mapBlock.getDoor(dir: dir)
            if (p.locked) {
                p.locked = false

                print("unlock door to \(dir)")

                return
            }
        }
    }
    
    func revealSecretDoor(at: MapPoint) {
        //get wall that has S
        let mapBlock = dungeon.getBlock(at)
        //perhaps we could pass in direction, as this would not work with > 1 secret door but I don't think that's a big concern:
        for dir in [Direction.north, .south, .east, .west] {
            let code = mapBlock.getWallCode(wallDir: dir)
            if (code == "S") {
                let p = mapBlock.getDoor(dir: dir)
                p.secret = false
                mapBlock.addCode(codeDir: dir, code: "D")
                let offset = getCardinalMoveVector(dir: dir)
                dungeon.getBlock(at + offset).addCode(codeDir: dir.opposite(), code: "D")
                print("reveal secret door to \(dir) and also fixup wall at \(dungeon.getBlock(at + offset).wallString)")
                renderTile(at)
                //revealSpot(at + offset)
                return
            }
        }
    }
    
    
    func canSee(from: MapPoint, to: MapPoint) -> Bool {
        
        //All we need is from and which way we're going:
        
        if (dungeon.currentLevel().offScreen(point: to)) {
            return false
        }
        
        let fromBlock = dungeon.getBlock(from)
        
        let dir = getDirFromVector(to - from)
        
        let dirWall = fromBlock.getWallCode(wallDir: dir)
        
        if (["W","D","S","0"].contains(dirWall)) {
            return false
        } else {
            //now check to walls
            let dirWall = dungeon.getBlock(to).getWallCode(wallDir: dir.opposite())
            if (["W","D","S","0"].contains(dirWall)) {
                return false
            } else {
                return true
            }
        }
    }
}
