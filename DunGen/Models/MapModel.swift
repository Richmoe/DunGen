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
    
    //Todo: Make array of maps
    
    
    
    var floor: [[Int]]
    
    var mapBlocks: [[MapBlock]]
    
    let mapWidth = 30
    let mapHeight = 30
    
    var depth = 0
    
    var passageQueue = [(MapPoint, Passage)]()
    
    var rooms = [Room]()
    
    var entrance : MapPoint
    var entranceLanding : MapPoint
    
    
    init() {
        
        var seedString = MapGenRand.getSeedString()
        print("THE SEED ___________ \(seedString) ___________")
        
        /* Interesting:
         9EEZ
         
         */
        //seedString = "X8LZ"
        
        MapGenRand.sharedInstance.setSeed(seedString: seedString)
        floor = Array(repeating: Array(repeating: 0, count: mapWidth), count: mapHeight)
        
        mapBlocks = Array(repeating: Array(repeating: MapBlock(), count: mapWidth), count: mapHeight)
        
        
        entrance = MapPoint(row: 1, col: Int(mapWidth / 2))
        entranceLanding = entrance + MapPoint(row: 1, col: 0)
        generateStart(at: entrance)
        processQueue()
        fixUpMap()
    }
    
    
    // MARK: - Move Queue
    
    func addToQueue(from: MapPoint, passage: Passage ) {
        
        passageQueue.append((from, passage))
        //print ("+++++Add to queue: \(from), \(passage), passageQueue count: \(passageQueue.count)")
    }
    
    func processQueue() {
        
        
        //testing
        //return
        var reRoll = false

        while (passageQueue.count > 0) {
            let (from, pass) = passageQueue.removeFirst()
            //print ("Next move: \(from) \(pass) queue count: \(passageQueue.count)")
            repeat {
                reRoll = false
                let moves = getPassageMoves()
                
                if (moves.count == 0) {
                    //reroll if I get a room connecting to a room via a hallway. Don't like that.
                    if (mapBlocks[from.row][from.col].tileCode == TileCode.floor && pass.type == .hallway) {
                        reRoll = true
                    } else {
                        generateRoom(from: from, entrance: pass)
                    }

                } else {
                    
                    doMoves(passageMoves: moves, fromPassage: pass, fromPt: from)
                }
                
            } while (reRoll == true)
            depth += 1
            
            if (depth > 100) {
                        print ("Total rooms: \(rooms.count)")
                return
            }
            
        }
        //
        //print ("_______QUEUE DONE_______")
        print ("Total rooms: \(rooms.count)")
    }
    
    func nextInQueue() {
        //for testing
        let (from, pass) = passageQueue.removeFirst()
        print ("-----Next move: \(from) \(pass) queue count: \(passageQueue.count)")
        let moves = getPassageMoves()
        
        if (moves.count == 0) {
            //print ("room?")
            generateRoom(from: from, entrance: pass)
        } else {
            //print("moves: \(moves)")
            doMoves(passageMoves: moves, fromPassage: pass, fromPt: from)
        }
        
    }
    
    
    // MARK: - Passage
    func getPassageMoves() -> [TileCode] {
        var passageMoves = [TileCode]()
        var r: Int
        //let r = Int.random(in: 1...19) //20)
        //let r = 10
        //Get rid of switch
        
        //let test = [4, 2, 2, 2, 4, 4, 2, 4, 4, 10, 2]
        repeat {
            r = MapGenRand.sharedInstance.getRand(to: 40)

            switch r {
            case 1...4:
                
                passageMoves = Array(repeating: TileCode.passage, count: r)
            case 5,6:
                passageMoves = [TileCode.passage, TileCode.doorRight, TileCode.passage]
            case 7,8:
                passageMoves = [TileCode.passage, TileCode.doorLeft, TileCode.passage]
            case 9,10:
                passageMoves = [TileCode.passage, TileCode.doorEnd]
            case 11...14:
                passageMoves = [TileCode.passage, TileCode.passageRight, TileCode.passage]
            case 15...18:
                passageMoves = [TileCode.passage, TileCode.passageLeft, TileCode.passage]
            case 19,20:

                //bias dead-ends later in the map. Don't want one right at the beginning.
                print ("In deaded - depth \(depth)")
                if (depth > 10) {
                    if (MapGenRand.sharedInstance.getRand(to: 10) == 1) {
                        passageMoves = [TileCode.passage, TileCode.secretEnd]
                    } else {
                        passageMoves = [TileCode.passage, TileCode.deadend]
                    }
                } else {
                    r = 0
                }
                
            case 21...24:
                passageMoves = [TileCode.passage, TileCode.passageRight, TileCode.passage]
            case 25...28:
                passageMoves = [TileCode.passage, TileCode.passageLeft, TileCode.passage]
            case 29...38:
                //Room
                //print("room")
                break
                
            default:
                print("stairs")
            }
        } while (r == 0)
        
        return passageMoves
    }
    
    
    func doMoves(passageMoves: [TileCode], fromPassage: Passage, fromPt: MapPoint)  {
        
        
        //let passageMoves = getPassageMoves()
        //let passageMoves = [TileCode.passage, TileCode.turnRight, TileCode.doorEnd, TileCode.passage, TileCode.deadend]
        //let passageMoves = [TileCode.passage, TileCode.passage]
        //let passageMoves = [TileCode.deadend]
        
        //print ("New Passage: \(passageMoves) heading: \(fromPassage.direction) from: \(fromPt)")
        
        //parse based on for input direction
        var curHeading = fromPassage
        var moveVector = getMoveVector(dir: fromPassage.direction)
        
        var curPoint = fromPt
        var prevPt = fromPt
        var pushEnd = true
        for move in passageMoves {
            
            prevPt = curPoint
            curPoint += moveVector
            //print ("Move: \(move) Ent: \(curHeading) at: \(curPoint)")
            
            
            //Check offScreen
            if (offScreen(point: curPoint)) {
                
                //print ("OFF SCREEN at \(curPoint)")
                //Here's where we cap it off
                mapBlocks[prevPt.row][prevPt.col].addWall(wallDir: curHeading.direction)
                
                return
            }
            
            //Check Overlap
            if (self.mapBlocks[curPoint.row][curPoint.col].tileCode != TileCode.null) {
                //Here's where we check for what to do
                //print("Overlap! at \(curPoint)")
                
//                if (curPoint.row == 1) {
//                    print("Break!")
//                }
                
                //Check to see what the block has in my direction:
                let code = self.mapBlocks[curPoint.row][curPoint.col].getWallCode(wallDir: curHeading.direction.opposite())
                //print ("the wall code at the collision is: \(code)")
                
                //For now just mirror that:
                mapBlocks[prevPt.row][prevPt.col].addCode(codeDir: curHeading.direction, code: code)
                
                return
            } else {
                mapBlocks[curPoint.row][curPoint.col] = MapBlock(tileCode: move, fromPassage: curHeading)
            }
            
            //for this next move, we assume passage
            curHeading = Passage(type: .hallway, direction: curHeading.direction)
            
            
            switch move {
            case TileCode.passage:
                break
            case TileCode.deadend:
                pushEnd = false
            case TileCode.passageRight, TileCode.secretRight:
                //generatePassage(fromPassage: Passage(type: .hallway, direction: curHeading.direction.right()), fromPt: curPoint)
                addToQueue(from: curPoint, passage: Passage(type: .hallway, direction: curHeading.direction.right()))
            case TileCode.doorRight:
                //generatePassage(fromPassage: Passage(type: .stone, direction: curHeading.direction.right()), fromPt: curPoint)
                addToQueue(from: curPoint, passage: Passage(type: .wooden, direction: curHeading.direction.right()))
                
            case TileCode.passageLeft, TileCode.secretLeft:
                //generatePassage(fromPassage: Passage(type: .stone, direction: curHeading.direction.left()), fromPt: curPoint)
                
                addToQueue(from: curPoint, passage: Passage(type: .hallway, direction: curHeading.direction.left()))
            case TileCode.doorLeft:
                //generatePassage(fromPassage: Passage(type: .stone, direction: curHeading.direction.left()), fromPt: curPoint)
                addToQueue(from: curPoint, passage: Passage(type: .wooden, direction: curHeading.direction.left()))
                
            case TileCode.doorEnd:
                //generatePassage(entrance: EntranceType(doorType: .stone, direction: entrance.direction), at: curPoint)
                curHeading = Passage(type: .wooden, direction: curHeading.direction)
                
                break
            case TileCode.secretEnd:
                //generatePassage(entrance: EntranceType(doorType: .stone, direction: entrance.direction), at: curPoint)
                curHeading = Passage(type: .secret, direction: curHeading.direction)
                
                break
            case TileCode.crossroad:
                //generatePassage(fromPassage: Passage(type: .hallway, direction: curHeading.direction.right()), fromPt: curPoint)
                //generatePassage(fromPassage: Passage(type: .hallway, direction: curHeading.direction.left()), fromPt: curPoint)
                
                addToQueue(from: curPoint, passage: Passage(type: .hallway, direction: curHeading.direction.right()))
                addToQueue(from: curPoint, passage: Passage(type: .hallway, direction: curHeading.direction.left()))
                
                
                
            case TileCode.turnLeft:
                curHeading = Passage(type: .hallway, direction: curHeading.direction.left())
                moveVector = getMoveVector(dir: curHeading.direction)
            case TileCode.turnRight:
                curHeading = Passage(type: .hallway, direction: curHeading.direction.right())
                
                moveVector = getMoveVector(dir: curHeading.direction)
            default:
                print("ERROR IN GENERATEPASSAGE - movcode: \(move)")
            }
            
            
        }
        
        if (pushEnd) {
            //            print("Done with moveblock, pushing end")
            //generatePassage(fromPassage: curHeading, fromPt: curPoint)
            addToQueue(from: curPoint, passage: curHeading)
            //
        } else {
            print("Deadend?")
        }
        
        return
    }
    
    
    
    
    //MARK: Starting Area
    func generateStart(at: MapPoint) {
        
        var room: Room
        var mapSpot = at
        
        //plot entrance:
        mapBlocks[mapSpot.row][mapSpot.col] = MapBlock(tileCode: .stairsUp, heading: .north)
        
        //Move one spot north
        mapSpot += MapPoint(row: 1, col: 0)
        
        //let r = Int.random(in: 1...10)
        let r = MapGenRand.sharedInstance.getRand(to: 10)
        print ("room type: \(r)")
        var passageTypes = [PassageType.hallway, PassageType.hallway, PassageType.hallway]
        switch r {
        case 1:
            room = Room(at: mapSpot, width: 3, height: 3)
        case 2:
            room = Room(at: mapSpot, width: 3, height: 3)
            passageTypes = [PassageType.wooden, PassageType.wooden, PassageType.hallway]
        case 3:
            room = Room(at: mapSpot, width: 5, height: 5)
            passageTypes = [PassageType.wooden, PassageType.wooden, PassageType.wooden]
        case 4:
            room = Room(at: mapSpot, width: 8, height: 2)
            

        case 5:
            room = Room(at: mapSpot, width: 2, height: 4)
        case 6:
            room = Room(at: mapSpot, width: 4, height: 4)
        case 7:
            room = Room(at: mapSpot, width: 4, height: 4)
        case 8:
            
            //special???
            room = Room(at: mapSpot, width: 5, height: 3)
            
        case 9, 10:
            
            //hall of stairs
            mapBlocks[mapSpot.row][mapSpot.col] = MapBlock(tileCode: .passage, fromPassage: Passage(type: .hallway, direction: .north))
            
            //crossroad
            mapSpot += MapPoint(row: 1, col: 0)
            mapBlocks[mapSpot.row][mapSpot.col] = MapBlock(tileCode: .turnRight, fromPassage: Passage(type: .hallway, direction: .north))
            
            //Hall to right
            var passage = Passage(type: .hallway, direction: .east)
            mapBlocks[mapSpot.row][mapSpot.col + 1] = MapBlock(tileCode: .passage, fromPassage: passage)
            addToQueue(from: MapPoint(row: mapSpot.row, col: mapSpot.col + 1), passage: passage)
            
            //Hall to left
            passage = Passage(type: .hallway, direction: .west)
            mapBlocks[mapSpot.row][mapSpot.col].addCode(exit: Passage(type: .hallway, direction: .west))
            mapBlocks[mapSpot.row][mapSpot.col - 1] = MapBlock(tileCode: .passage, fromPassage: passage)
            addToQueue(from: MapPoint(row: mapSpot.row, col: mapSpot.col - 1), passage: passage)
            
            if (r == 10) {
                //Hall North
                passage = Passage(type: .hallway, direction: .north)
                mapBlocks[mapSpot.row][mapSpot.col].addCode(exit: Passage(type: .hallway, direction: .north))
                mapBlocks[mapSpot.row + 1][mapSpot.col] = MapBlock(tileCode: .passage, fromPassage: passage)
                addToQueue(from: MapPoint(row: mapSpot.row + 1, col: mapSpot.col), passage: passage)
            }
            
            return
        default: //error?:
            room = Room(at: mapSpot, width: 4, height: 4)
        }
        
        
        let entrancePoint = MapPoint(row: 0, col: Int(room.width / 2))
        
        room.setExit(at: entrancePoint, exit: Passage(type: .stairsUp, direction: .south))
        
        room.at -= entrancePoint
        
        if (r <= 8) {

            let pType = (MapGenRand.sharedInstance.shuffle(array: passageTypes))
            
            var at = MapPoint(row: Int(room.height / 2), col: room.width - 1)
            var exit = Passage(type: pType[0] as! PassageType, direction: .east)
            
            room.setExit(at: at, exit: exit)
            addToQueue(from: room.at + at, passage: exit)
            
            at = MapPoint(row: Int(room.height / 2), col: 0)
            exit = Passage(type: pType[1] as! PassageType, direction: .west)
            room.setExit(at: at, exit: exit)
            addToQueue(from: room.at + at, passage: exit)
            
            if (r == 4) {
                //quarters
                at = MapPoint(row: room.height - 1, col: 1)
                exit = Passage(type: pType[2] as! PassageType, direction: .north)
                room.setExit(at: at, exit: exit)
                addToQueue(from: room.at + at, passage: exit)
                
                at = MapPoint(row: room.height - 1, col: 6)
                exit = Passage(type: pType[2] as! PassageType, direction: .north)
                room.setExit(at: at, exit: exit)
                addToQueue(from: room.at + at, passage: exit)
            } else {
                //center
                at = MapPoint(row: room.height - 1, col: Int(room.width / 2))
                exit = Passage(type: pType[2] as! PassageType, direction: .north)
                room.setExit(at: at, exit: exit)
                addToQueue(from: room.at + at, passage: exit)
            }
        }
        
        plotRoom(room: room)
        
    }
    
    
    
    //MARK: Rooms
    func generateRoom(from: MapPoint, entrance: Passage) -> Bool {
        
        //Get a random sized room
        var tries = 10
        while tries > 0 {
            
            let room = Room(at: from + getMoveVector(dir: entrance.direction))   //Todo fix up we don't need the at here
            
            
            if (placeRoom(room: room, entrance: entrance)) {
                return true
            }
            tries -= 1
            
        }
        
        return false
    }
    
    func placeRoom(room: Room, entrance: Passage) -> Bool {
        
        //locate exit in room
        let entrancePassage = Passage(type: entrance.type, direction: entrance.direction.opposite())
        let entrancePt = room.getRandomExit(exit: entrancePassage)
        room.setExit(at: entrancePt, exit: entrancePassage)
        
        
        //shift edge of room based on entrance orientation:
        //where entrance.direction is facing INTO the room
        // entrancePt is relative to room (where 0,0 = SW corner
        
        
        //print ("Generating room: w \(room.width), h \(room.height) starting at: \(room.at) entrance: \(entrance), entrancePT: \(entrancePt)")
        //if we are heading north, the room is at + height (positive
        switch entrance.direction { //heading
        case .north:
            room.at -= MapPoint(row : 0, col: entrancePt.col)
        case .east:
            room.at -= MapPoint(row : entrancePt.row, col: 0)
        case .south:
            room.at -= MapPoint(row : (room.height - 1), col: entrancePt.col)
        default: //west
            room.at -= MapPoint(row : entrancePt.row, col: (room.width - 1))
        }
        
        //check offscreen
        if (offScreen(ptLL: room.at, ptUR: room.at + MapPoint(row: room.height - 1, col: room.width - 1))) {
            //print ("Offscreen! Aborting")
            return false
        }
        
        if (doesOverlap(room: room)) {
            //print("Overlapping! Aborting")
            return false
        }
        
        //Get exits here?
        var exits = room.getExitCount()
        
        while (exits > 0) {
            exits -= 1
            
            let (exitAt, passage) = room.generateRandomExit(entrance: entrance)
            
            if (exitAt.row != -1) {
                //we could check bounds but fixup would fix it up
                
                //so we'll just plop it and plot room below will take care of it
                room.setExit(at: exitAt, exit: passage)
                //generatePassage(fromPassage: passage, fromPt: exitAt + room.at)
                addToQueue(from: exitAt + room.at, passage: passage)
                
            }
            
            //print ("exit: \(exitAt), \(passage)")
        }
        
        
        
        plotRoom(room: room)
        return true
    }
    
    func plotRoom(room: Room) {
        let startPt = room.at
        let roomWidth = room.width
        let roomHeight = room.height
        
        for r in startPt.row...(startPt.row + roomHeight - 1) {
            for c in startPt.col...(startPt.col + roomWidth - 1) {
                mapBlocks[r][c] = room.floorBlocks[r - startPt.row][c - startPt.col]
            }
        }
        
        rooms.append(room)
    }
    
    
    
    // MARK: Print
    
    
    func printFloorplan(floorPlan: [[Int]], at: MapPoint) {
        var tempMap = Array(repeating: Array(repeating: 0, count: mapWidth), count: mapHeight)
        for r in at.row...at.row + floorPlan.count - 1{
            for c in at.col...at.col + floorPlan[0].count - 1 {
                tempMap[r][c] = floorPlan[r - at.row][c - at.col]
            }
        }
        printFloor(floor: tempMap)
    }
    
    func printMapBlocks() {
        
        var str = ""
        for r in (0..<floor.count).reversed() {
            str = "\(String(format: "%02d", r)): "
            for c in 0..<floor[r].count {
                str += "\(mapBlocks[r][c] )"
                str += " "
            }
            print(str)
        }
        str = "    "
        for c in 0..<floor[0].count {
            str += "\(String(format: "%02d", c)) "
        }
        print (str)
    }
    
    func printFloor(floor: [[Int]]) {
        var str = ""
        for r in (0..<floor.count).reversed() {
            str = "\(String(format: "%02d", r)): "
            for c in 0..<floor[r].count {
                str += String(format: "%02d", floor[r][c])
                str += " "
            }
            print(str)
        }
        str = "    "
        for c in 0..<floor[0].count {
            str += "\(String(format: "%02d", c)) "
        }
        print (str)
    }
    
    //MARK: Fixup
    
    func fixUpMap() {
        
        
        var codeThis : Character
        var codeThat : Character
        
        for r in (0..<mapBlocks.count) {
            for c in 0..<mapBlocks[r].count  {
                
                if (r < (mapHeight - 1)) {
                    
                    codeThis = mapBlocks[r][c].getWallCode(wallDir: .north)
                    codeThat = mapBlocks[r+1][c].getWallCode(wallDir: .south)
                    
                    //if combo w/p,
                    
                    //Check if N of this is equal to S of R+1
                    if (codeThis != codeThat && String([codeThis,codeThat]) != "0W" && String([codeThis,codeThat]) != "W0" && codeThis != "+" && codeThat != "+" && codeThis != "-" && codeThat != "-")  {
                        //wall off if r or r+1 = 0 but skip if W + 0
                        //print ("Fixing up NS at \(r), \(c): this(lower): \(mapBlocks[r][c].wallString), upper: \(mapBlocks[r+1][c].wallString)")
                        if (["DP", "PD"].contains(String([codeThis, codeThat]))) {
                            mapBlocks[r+1][c].addCode(codeDir: .south, code: "D")
                            mapBlocks[r][c].addCode(codeDir: .north, code: "D")
                        } else                         if (["SP", "PS"].contains(String([codeThis, codeThat]))) {
                            mapBlocks[r+1][c].addCode(codeDir: .south, code: "S")
                            mapBlocks[r][c].addCode(codeDir: .north, code: "S")
                        } else if (codeThis == "0") {
                            mapBlocks[r+1][c].addWall(wallDir: .south)
                        } else if (codeThat == "0") {
                            mapBlocks[r][c].addWall(wallDir: .north)
                        } else {
                            //pick one to be authority:
                            //if (Int.random(in: 0...1) == 0) {
                            if (MapGenRand.sharedInstance.getRand(to: 2) == 2) {
                                mapBlocks[r+1][c].addCode(codeDir: .south, code: codeThis)
                                
                            } else  {
                                mapBlocks[r][c].addCode(codeDir: .north, code: codeThat)
                            }
                        }
                        
                        //print ("---after \(r), \(c): this(lower): \(mapBlocks[r][c].wallString), upper: \(mapBlocks[r+1][c].wallString)")
                    }
                }
                
                if (c < (mapWidth - 1)) {
                    
                    //Check if E of this is equal to W of C+1
                    codeThis = mapBlocks[r][c].getWallCode(wallDir: .east)
                    codeThat = mapBlocks[r][c+1].getWallCode(wallDir: .west)
                    if (codeThis != codeThat && String([codeThis,codeThat]) != "0W" && String([codeThis,codeThat]) != "W0" && codeThis != "+" && codeThat != "+" && codeThis != "-" && codeThat != "-") {
                        //print ("Fixing up EW at \(r), \(c): west: \(mapBlocks[r][c].wallString), east: \(mapBlocks[r][c+1].wallString)")
                        if (["DP", "PD"].contains(String([codeThis, codeThat]))) {
                            mapBlocks[r][c+1].addCode(codeDir: .west, code: "D")
                            mapBlocks[r][c].addCode(codeDir: .east, code: "D")
                        } else                         if (["SP", "PS"].contains(String([codeThis, codeThat]))) {
                            mapBlocks[r][c+1].addCode(codeDir: .west, code: "S")
                            mapBlocks[r][c].addCode(codeDir: .east, code: "S")
                        } else if (codeThis == "0" || mapBlocks[r][c].tileCode == TileCode.stairsUp || mapBlocks[r][c].tileCode == TileCode.stairsDown) {
                            mapBlocks[r][c+1].addWall(wallDir: .west)
                        } else if (codeThat == "0" || mapBlocks[r][c].tileCode == TileCode.stairsUp || mapBlocks[r][c].tileCode == TileCode.stairsDown) {
                            mapBlocks[r][c].addWall(wallDir: .east)
                        } else {
                            //pick one to be authority:
                            //if (Int.random(in: 0...1) == 0) {
                            if (MapGenRand.sharedInstance.getRand(to: 2) == 2) {
                                mapBlocks[r][c+1].addCode(codeDir: .west, code: codeThis)
                                
                            } else  {
                                mapBlocks[r][c].addCode(codeDir: .east, code: codeThat)
                            }
                        }
                        //print ("---after \(r), \(c): this(lower): \(mapBlocks[r][c].wallString), upper: \(mapBlocks[r+1][c].wallString)")
                        
                    }
                }
            }
        }
    }
    
    
    // MARK: - Helpers
    //func doesOverlap(map: [[Int]]) -> Bool {
    func doesOverlap(room: Room) -> Bool {
        for r in 0...(room.height - 1) {
            let rm = r + room.at.row
            for c in 0...(room.width - 1) {
                let cm = c + room.at.col
                if (self.mapBlocks[rm][cm].tileCode != TileCode.null) {
                    //if (floor[rm][cm] > 0) {
                    //print("Overlap at r:c \(rm):\(cm)")
                    return true
                }
            }
        }
        return false
    }
    
    func doesOverlap(layout: [[Int]], at: MapPoint) -> Bool {
        for r in 0...(layout.count - 1) {
            let rm = r + at.row
            for c in 0...(layout[0].count - 1) {
                let cm = c + at.col
                if (floor[rm][cm] > 0) { //TODO: we could check pixels in source...
                    //print("Overlap at r:c \(rm):\(cm)")
                }
            }
        }
        return false
    }//We will leave a 1 block border around the map to make the fixup work.
    
    
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
    
    func loadFromResource(fileName: String) {
        
        let path = Bundle.main.path(forResource: fileName, ofType: nil)
        do {
            let fileContents = try String(contentsOfFile:path!, encoding: String.Encoding.utf8)
            let lines = fileContents.components(separatedBy: "\n")
            
            for row in 0..<lines.count {
                let items = lines[row].components(separatedBy: " ")
                var str = ""
                for column in 0..<items.count {
                    str += items[column] + " "
                }
                print ("row: \(row): \(str)")
            }
        } catch {
            print("Error loading map")
        }
    }
    
}

