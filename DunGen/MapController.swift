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
    
    init(dungeon: Dungeon, tileMap: SKTileMapNode) {
        
        self.dungeon = dungeon
        
        self.tileMap = tileMap
    }
    
    func clickAt(_ clickPt: CGPoint) {
        
        //Todo: we should probably figure out intent on click but for now we just move
        if (Global.isMoving) {
            return
        }
        
        
        //Check the grid we clicked on. If self, ignore
        let clickSpot = dungeon.currentLevel().cgPointToMap(clickPt)
        
        moveTo(clickSpot)

    }
    
    func moveTo(_ toMap: MapPoint) {
        
        if (toMap == Global.adventure.party.at) {
            print("SAME!!!")
            return
        }
        
        let direction = angleToCardinalDir(angleBetween(fromMap: Global.adventure.party.at, toMap: toMap))
        
        let moveVector = getCardinalMoveVector(dir: direction)
        let stepMove = Global.adventure.party.at + moveVector
        
        if (dungeon.canEnter(toPt: stepMove, moveDir: direction)) {
            
            //Do the move
            let movePt = dungeon.currentLevel().MapPointCenterToCGPoint(stepMove)
            
            Global.adventure.party.moveParty(toPt: movePt, toTile: MapPoint(row: stepMove.row, col: stepMove.col))
            //just in case:
            renderTile(stepMove)
            
            fogOfWar()
        }
        
    }
    
    func placeParty() {
        goToTile(dungeon.getPlayerEntrance())
        fogOfWar()
    }
    
    
    func goToTile(_ tile: MapPoint) {
        let movePt = tileMap.centerOfTile(atColumn: tile.col, row: tile.row)
        
        Global.adventure.party.setAt(atPt: movePt, atTile: MapPoint(row: tile.row, col: tile.col))
        
        renderTile(tile)
    }

    
    func renderTile(_ mp: MapPoint) {
        
        let mb = dungeon.getBlock(mp)
        if let groupIx = Global.mapTileSet.tileDict[mb.wallString] {
            //print ("rendering tile \(tile.wallString): \(groupIx) at c/R: \(col), \(row)")
            tileMap.setTileGroup(tileMap.tileSet.tileGroups[groupIx], forColumn: mp.col, row: mp.row)
        } else {
            if (mb.wallString != "0000") {
                print ("Can't find tile: \(mb.wallString) at rc: \(mp.row), \(mp.col)")
            }
        }
    }
    
    
    func fogOfWar() {
        //input new position
        
        for a in 0...59 { //6deg increments
            let ang = 6 * Double(a)
            let x = sin(ang  * (.pi / 180))
            let y = cos(ang * (.pi / 180))
            var fromPt = Global.adventure.party.at
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
                        renderTile(toPt)
                        fromPt = toPt
                    } else {
                        break
                    }
                }
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
