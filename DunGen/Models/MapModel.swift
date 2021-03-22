//
//  MapModel.swift
//  AdventureDungeon
//
//  Created by Richard Moe on 4/8/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation
import CoreGraphics



class Map {
    
    
    var mapBlocks: [[MapBlock]]
    
    let mapWidth : Int
    let mapHeight : Int

    
    var rooms = [Room]()
    
    var entranceLanding : MapPoint?
    
    //For generation
    var depth = 0
    var passageQueue = [(MapPoint, Passage)]()
    
    
    init(width: Int, height: Int) {

        mapWidth = width
        mapHeight = height
        
        mapBlocks = Array(repeating: Array(repeating: MapBlock(), count: mapWidth), count: mapHeight)
        
    }
    
    func getRoom(mapPt: MapPoint) -> Int {
        
        for r in rooms {
            if (r.at.col <= mapPt.col && (r.at.col + r.width) >= mapPt.col) {
                if (r.at.row <= mapPt.row && (r.at.row + r.height) >= mapPt.row) {
                    return r.id
                }
            }
        }
        
        return 0
    }

    
    // MARK: Point conversions
    
    //Convert map point to CGPoint
    func MapPointToCGPoint(_ mapPoint: MapPoint) -> CGPoint {
        //Note that CGPoint = -.5*MaxHW to +.5*MaxHW
        let x = mapPoint.col * MapTileSet.tileWidth - (mapWidth * MapTileSet.tileWidth / 2)
        let y = mapPoint.row * MapTileSet.tileHeight - (mapHeight * MapTileSet.tileHeight / 2)
        
        return CGPoint(x: x, y: y)
    }
    
    func MapPointCenterToCGPoint(_ mapPoint: MapPoint) -> CGPoint {
        return MapPointToCGPoint(mapPoint) + CGPoint(x: MapTileSet.tileWidth / 2, y: MapTileSet.tileHeight / 2)
    }
    
    
    //BattleMap
    func BattleMapPointToCGPoint(_ battleMapPoint: MapPoint) -> CGPoint {
        let x = battleMapPoint.col * MapTileSet.tileWidth / 2 - (mapWidth * MapTileSet.tileWidth / 2)
        let y = battleMapPoint.row * MapTileSet.tileWidth / 2 - (mapHeight * MapTileSet.tileHeight / 2)
        
        return CGPoint(x: x, y: y)
    }
    
    func BattleMapPointCenterToCGPoint(_ battleMapPoint: MapPoint) -> CGPoint {
        return BattleMapPointToCGPoint(battleMapPoint) + CGPoint(x: MapTileSet.tileWidth / 4, y: MapTileSet.tileHeight / 4)
    }
    
    
    
    
    //Convert CGPoint to map Point
    func CGPointToMapPoint(_ pt: CGPoint) -> MapPoint {
        //Note that CGPoint = -.5*MaxHW to +.5*MaxHW
        //normalize click:
        let nPt = pt + CGPoint(x: mapWidth * MapTileSet.tileWidth / 2, y: mapHeight * MapTileSet.tileHeight / 2)
        
        let fmpc = (nPt.x / CGFloat(MapTileSet.tileWidth))
        let fmpr = (nPt.y / CGFloat(MapTileSet.tileHeight))
        
        return MapPoint(row: Int(fmpr), col: Int(fmpc))
    }
    
    //Convert CGPoint to map Battle Spot
    func CGPointToBattleMapPoint(_ pt: CGPoint) -> MapPoint {
        //Note that CGPoint = -.5*MaxHW to +.5*MaxHW
        //normalize click:
        let nPt = pt + CGPoint(x: mapWidth * MapTileSet.tileWidth / 2, y: mapHeight * MapTileSet.tileHeight / 2)
        
        let fmpc = (nPt.x / CGFloat(MapTileSet.tileWidth / 2))
        let fmpr = (nPt.y / CGFloat(MapTileSet.tileHeight / 2))
        
        return MapPoint(row: Int(fmpr), col: Int(fmpc))
    }
    
    
    
    // MARK: - Helpers
    func canEnter(toPt: MapPoint, moveDir: Direction) -> Bool {
        
        let toType = getBlock(toPt) //mapBlocks[toMP.row][toMP.col]
        
        //print("Can enter: \(toType.tileCode)? ")
        
        if (toType.tileCode == TileCode.null) {
            return false
        } else {
            //Check wall
            let dirWall = toType.getWallCode(wallDir: moveDir.opposite())
            if (dirWall == "W" || dirWall == "S") {
                return false
            } else {
                if (dirWall == "D") {
                    let passage = toType.getDoor(dir: moveDir.opposite())
                    if (passage.locked || passage.secret) {
                        //Do we have secret at this point???
                        
                        if (passage.locked) {
                            Global.adventure.setStatus("The door is locked.", timed: true)
                        }
                        print("DOOR IS LOCKED or SECRET!!!")
                        return false
                    } else {
                        //Todo: Figure out traps
                        return true
                    }
                } else {
                    return true
                }
                
            }
        }
    }
    
    
    
    func getBlock(_ pt: MapPoint) -> MapBlock {
        if (!offScreen(point: pt)) {
            return mapBlocks[pt.row][pt.col]
        } else {
            return MapBlock()
        }
    }
    
    func getBlock(row: Int, col: Int) -> MapBlock {
        
        if (!offScreen(point: MapPoint(row: row, col: col))) {
            return mapBlocks[row][col]
        } else {
            return MapBlock()
        }
    }
    
    func getBlock(at: MapPoint, dir: Direction) -> MapBlock? {
        
        if (!offScreen(point: at)) {
            let offset = getMoveVector(dir: dir)
            if (!offScreen(point: at + offset)) {
                return mapBlocks[at.row + offset.row][at.col + offset.col]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func setBlock(at: MapPoint, block: MapBlock) {
        
        if (offScreen(point: at)) {
            print("Error!")
        } else {
            mapBlocks[at.row][at.col] = block
        }
    }
    

    
    func offScreen(point: MapPoint) -> Bool {
        if (point.col < 1 || point.col >= (mapWidth - 1) || point.row < 1 || point.row >= (mapHeight - 1)) {
            return true
        } else {
            return false
        }
    }
    
    //Check two points of rect
    func offScreen(ptLL: MapPoint, ptUR: MapPoint ) -> Bool {
        
        if (ptLL.col < 1 || ptLL.row < 1) {
            return true
        }
        
        if (ptUR.col >= (mapWidth - 1) || ptUR.row >= (mapHeight - 1)) {
            return true
        }
        
        return false
    }
    
    //    func loadFromResource(fileName: String) {
    //        
    //        let path = Bundle.main.path(forResource: fileName, ofType: nil)
    //        do {
    //            let fileContents = try String(contentsOfFile:path!, encoding: String.Encoding.utf8)
    //            let lines = fileContents.components(separatedBy: "\n")
    //            
    //            for row in 0..<lines.count {
    //                let items = lines[row].components(separatedBy: " ")
    //                var str = ""
    //                for column in 0..<items.count {
    //                    str += items[column] + " "
    //                }
    //                print ("row: \(row): \(str)")
    //            }
    //        } catch {
    //            print("Error loading map")
    //        }
    //    }
    
}

