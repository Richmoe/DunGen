//
//  MapBlockModel.swift
//  AdventureDungeon
//
//  Created by Richard Moe on 4/18/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation

class MapBlock {
    
    
    var wallString = "0000"
    var tileCode = TileCode.null
    
    var encounter: Encounter?
    //P - Passage
    //E - dead end
    //W
    //D
    //S
    //+ = stairs up
    //- = stairs down
    
    //Since we only care about NESW, no diags, each char represents a dir: NESW
    
    //To plot walls, we need a code and a direction.
    
    //All values assume N
    
    //To rotate CCW we pop the first char and push it to the end.
    
    
    //to flip, do CW*2
    //To rotate CCW, CW*2
    
    init() {
        //Required stub
    }
    
    func rotCCW() {
        wallString.append(wallString.removeFirst())
    }
    
    func rotCW() {
        wallString.insert(wallString.removeLast(), at: wallString.startIndex)
    }
    
    init (tileCode: TileCode, heading: Direction) {
        self.tileCode = tileCode
        tileCodeToWallString(tileCode: tileCode)
        
        rotateForDir(heading: heading)
        
        //print("plotting block string: \()')
    }
    
    init (tileCode: TileCode, fromPassage: Passage) {
        
        self.tileCode = tileCode
        tileCodeToWallString(tileCode: tileCode)
        
        rotateForDir(heading: fromPassage.direction)
        
        //Probably need to store off door info?
        
        
        //print ("Code, type: \(tileCode), \(fromPassage.type): Before: \(wallString)")
        if (fromPassage.type == .hallway) {
            addCode(codeDir: fromPassage.direction.opposite(), code: "P")
        } else if (fromPassage.type == .secret || fromPassage.type == .secretLocked) {
            addCode(codeDir: fromPassage.direction.opposite(), code: "W")
        } else { //door
            addCode(codeDir: fromPassage.direction.opposite(), code: "D")
        }
        
        // print ("After: \(wallString)")
    }
    
    func rotateForDir(heading: Direction) {
        if (heading.rawValue > Direction.north.rawValue) {
            rotCW()
        }
        if (heading.rawValue > Direction.east.rawValue) {
            rotCW()
        }
        if (heading.rawValue > Direction.south.rawValue) {
            rotCW()
        }
        
        //print ("block string is now : \(wallString)")
    }
    
    func tileCodeToWallString (tileCode: TileCode) {
        switch tileCode {
        case .deadend:
            wallString = "WWPW"
        case .passage:
            wallString = "PWPW"
        case .passageRight:
            wallString = "PPPW"
        case .passageLeft:
            wallString = "PWPP"
        case .crossroad, .floor:
            wallString = "PPPP"
        case .turnLeft:
            wallString = "WWPP"
        case .turnRight:
            wallString = "WPPW"
        case .doorLeft:
            wallString = "PWPD"
        case .doorRight:
            wallString = "PDPW"
        case .doorEnd:
            wallString = "DWPW"
        case .secretLeft:
            wallString = "PWPS"
        case .secretRight:
            wallString = "PSPW"
        case .secretEnd:
            wallString = "SWPW"
        case .roomUL:
            wallString = "PWWP"
        case .roomUR:
            wallString = "PPWW"
        case .roomLL:
            wallString = "WWPP"
        case .roomLR:
            wallString = "WPPW"
        case .singleWall:
            wallString = "WPPP"
        case .stairsDown:
            wallString = "-WWW"
        case .stairsUp:
            wallString = "+WWW"
        default:
            print("No String for code: \(tileCode)")
            break
        }
        
    }
    
    func addWall(wallDir: Direction) {
        
        //        if (tileCode == TileCode.null) {
        ////            print ("xxx")
        //            return
        //        }
        //        //print("Adding wall to the \(wallDir) (was \(wallString)")
        //        var chars = Array(wallString)     // gets an array of characters
        //        let ix = Int(wallDir.rawValue / 2)
        //
        //        chars[ix] = "W"
        //
        //        wallString = String(chars)
        addCode(codeDir: wallDir, code: "W")
    }
    
    func addDoor(doorDir: Direction) {
        //        //print("Adding door to the \(doorDir) (was \(wallString)")
        //        var chars = Array(wallString)     // gets an array of characters
        //        let ix = Int(doorDir.rawValue / 2)
        //
        //        chars[ix] = "D"
        //
        //        wallString = String(chars)
        
        addCode(codeDir: doorDir, code: "D")
    }
    func addCode(codeDir: Direction, code: Character) {
        //print("Adding \(code) to the \(codeDir) (was \(wallString)")
        
        if (tileCode == TileCode.null) {
            return
        }
        var chars = Array(wallString)     // gets an array of characters
        let ix = Int(codeDir.rawValue / 2)
        
        chars[ix] = code
        
        wallString = String(chars)
    }
    
    func addCode(exit: Passage) {
        
        if (tileCode == TileCode.null) {
            print ("xxx")
        }
        //get code from entrance type:
        let code : Character
        if (exit.type == .hallway) {
            code = "P"
        } else if (exit.type == .secret || exit.type == .secretLocked) {
            code = "W"
        } else if (exit.type == .stairsUp) {
            code = "P"
        } else if (exit.type == .stairsDown) {
            code = "P"
        } else { //door
            code = "D"
        }
        addCode(codeDir: exit.direction, code: code)
    }
    
    func getWallCode(wallDir: Direction) -> Character {
        //bias toward walls on diagonal
        let chars = Array(wallString)
        var c: Character
        switch wallDir {
        case .north:
            c = chars[0]
        case .east:
            c = chars[1]
        case .south:
            c = chars[2]
        case .west:
            c = chars[3]
        case .northeast:
            c = chars[0]
            if (c != "W") {
                c = chars[1]
            }
        case .northwest:
            c = chars[0]
            if (c != "W") {
                c = chars[3]
            }
        case .southeast:
            c = chars[2]
            if (c != "W") {
                c = chars[1]
            }
        case .southwest:
            c = chars[2]
            if (c != "W") {
                c = chars[3]
            }
        }
        return c
    }
    
}

/*
 For a floor unit, we need:
 location
 reference orientation
 type:
 - passage
 - through
 - branch
 - deadend
 - passage with door
 - door type
 - door orientation
 -stair
 - up/down
 - where all branches relative to orientation?
 
 
 
 Another way to look at it:
 - A map code is just the sum of what is on its 4 walls?
 
 - Do we build a wall code from a tile group? That would take a 2d array with padding? With orientation we can fill the array with the computed code by looking at all 4 directions relative to the tile
 - this implies padding
 - actually we could build the tile by grabbing the real world map 3x3 and placing new tile there. Benefit is we would also catch overlaps, dead-ends, and merge.
 
 
 //Refactor map to be class with:
 // getMapBlock (spot)
 // getMapBlock (rect)
 // plotBlock( block, spot)
 // plotBlock ( rect or Room)
 // var map = [[Int]]
 
 // checkBlock (spot)
 // checkBlock (rect)
 
 // printMap
 
 // Map passed into render?
 
 
 With this class, passage generation:
 1) Generate pattern
 2) for each pattern:
 3) - build block
 4) - pass into map
 
 or is it:
 - pass pattern to Map as it knows what to do?
 - Is pattern a 3x3 itself???
 EG: for passage:
 
 0 W 0
 P X P
 0 W 0
 
 0 P 0
 P P W
 0 W 0
 
 0 W 0
 P P W
 0 W 0
 
 
 
 Passage:
 0p0
 0p0
 0p0
 
 or code = NESW so
 passage = 1010
 
 
 x['P'] = ["xpx
 xxx xpx"
 
 Passage Left
 1011
 0p0
 px0
 0p0
 
 passasge right
 1110
 
 0p0
 0pp
 0p0
 
 crossroad:
 1111
 0p0
 pxp
 0p0
 
 deadend
 0010
 
 000
 0x0
 0p0
 
 door left
 1012
 0p0
 dx0
 0p0
 
 door right
 1210
 0p0
 0xd
 0p0
 
 door end
 2010
 0d0
 0x0
 0p0
 
 turn right
 0110
 000
 
 0pp
 0p0
 
 turn left
 0011
 
 000
 pp0
 0p0
 
 Notice we ignore row 3
 
 
 
 
 
 
 where W = Wall, Door, Secret Door?
 
 P - Open
 W - wall
 D - Door
 S - Secret
 
 So we passin pattern and direction, and rotate appropriately?
 */
