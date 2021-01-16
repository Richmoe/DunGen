//
//  MapGenerator.swift
//  DunGen
//
//  Created by Richard Moe on 6/14/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation


class MapGenerator {
    
    let map : Map
    
    //For generation
    var depth = 0
    var passageQueue = [(MapPoint, Passage)]()
    
    init(map: Map) {
        
        self.map = map
        
        let ent = MapPoint(row: 1, col: Int(map.mapWidth / 2))
        map.entranceLanding = ent + MapPoint(row: 1, col: 0)
        generateStart(at: ent)
        processQueue()
        fixUpMap()
    }
    
    
    // MARK: - Move Queue
    
    func addToQueue(from: MapPoint, passage: Passage ) {
        
        passageQueue.append((from, passage))
        //print ("+++++Add to queue: \(from), \(passage), passageQueue count: \(passageQueue.count)")
    }
    
    func processQueue() {
        
        var reRoll = false
        
        while (passageQueue.count > 0) {
            let (from, pass) = passageQueue.removeFirst()
            //print ("Next move: \(from) \(pass) queue count: \(passageQueue.count)")
            repeat {
                reRoll = false
                let moves = getPassageMoves()
                
                if (moves.count == 0) {
                    //reroll if I get a room connecting to a room via a hallway. Don't like that.
                    if (map.getBlock(from).tileCode == TileCode.floor && pass.type == .hallway) {
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
                print ("Total rooms: \(map.rooms.count)")
                return
            }
            
        }
        //
        //print ("_______QUEUE DONE_______")
        print ("Total rooms: \(map.rooms.count)")
    }
    
    func DEBUG_nextInQueue() {
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
        var roll: Int
        //let r = Int.random(in: 1...19) //20)
        //let r = 10
        //Get rid of switch
        
        //let test = [4, 2, 2, 2, 4, 4, 2, 4, 4, 10, 2]
        repeat {
            roll = DGRand.sharedInstance.getRand(to: 40)
            
            switch roll {
            case 1...4:
                
                passageMoves = Array(repeating: TileCode.passage, count: roll)
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
                if (depth > 0) {
                    if (DGRand.sharedInstance.getRand(to: 10) > 5) {
                        print("SSSEEECDREETTTK")
                        passageMoves = [TileCode.passage, TileCode.secretEnd]
                    } else {
                        passageMoves = [TileCode.passage, TileCode.deadend]
                    }
                } else {
                    roll = 0
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
        } while (roll == 0)
        
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
            
            
            //Check offScreen
            if (map.offScreen(point: curPoint)) {
                
                //print ("OFF SCREEN at \(curPoint)")
                //Here's where we cap it off
                //map.mapBlocks[prevPt.row][prevPt.col].addWall(wallDir: curHeading.direction)
                map.getBlock(prevPt).addWall(wallDir: curHeading.direction)
                
                return
            }
            
            //Check Overlap
            if (map.getBlock(curPoint).tileCode != TileCode.null) {
                //Here's where we check for what to do
                //print("Overlap! at \(curPoint)")
                
                
                //Check to see what the block has in my direction:
                let code = map.getBlock(curPoint).getWallCode(wallDir: curHeading.direction.opposite())
                //print ("the wall code at the collision is: \(code)")
                
                //For now just mirror that:
                map.getBlock(prevPt).addCode(codeDir: curHeading.direction, code: code)
                
                return
            } else {
                map.setBlock(at: curPoint, block: MapBlock(tileCode: move, fromPassage: curHeading))
            }
            
            //for this next move, we assume passage
            curHeading = Passage(type: .hallway, direction: curHeading.direction)
            
            
            switch move {
            case TileCode.passage:
                break
            case TileCode.deadend:
                pushEnd = false
            case TileCode.passageRight, TileCode.secretRight:
                addToQueue(from: curPoint, passage: Passage(type: .hallway, direction: curHeading.direction.right()))
            case TileCode.doorRight:
                addToQueue(from: curPoint, passage: Passage(type: .wooden, direction: curHeading.direction.right()))
            case TileCode.passageLeft, TileCode.secretLeft:
                addToQueue(from: curPoint, passage: Passage(type: .hallway, direction: curHeading.direction.left()))
            case TileCode.doorLeft:
                addToQueue(from: curPoint, passage: Passage(type: .wooden, direction: curHeading.direction.left()))
            case TileCode.doorEnd:
                curHeading = Passage(type: .wooden, direction: curHeading.direction)
                break
            case TileCode.secretEnd:
                curHeading = Passage(type: .secret, direction: curHeading.direction)
                break
            case TileCode.crossroad:
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
            addToQueue(from: curPoint, passage: curHeading)
        } else {
            print("Deadend?")
        }
    }
    
    
    
    
    //MARK: Starting Area
    func generateStart(at: MapPoint) {
        
        var room: Room
        var mapSpot = at
        
        //plot entrance:
        map.setBlock(at: mapSpot, block: MapBlock(tileCode: .stairsUp, heading: .north))
        
        //Move one spot north
        mapSpot += MapPoint(row: 1, col: 0)
        
        //let r = Int.random(in: 1...10)
        let roll = DGRand.sharedInstance.getRand(to: 10)
        print ("room type: \(roll)")
        var passageTypes = [PassageType.hallway, PassageType.hallway, PassageType.hallway]
        switch roll {
        case 1:
            room = RoomFactory.sharedInstance.makeRoom(at: mapSpot, width: 3, height: 3)
        case 2:
            room = RoomFactory.sharedInstance.makeRoom(at: mapSpot, width: 3, height: 3)
            passageTypes = [PassageType.wooden, PassageType.wooden, PassageType.hallway]
        case 3:
            room = RoomFactory.sharedInstance.makeRoom(at: mapSpot, width: 5, height: 5)
            passageTypes = [PassageType.wooden, PassageType.wooden, PassageType.wooden]
        case 4:
            room = RoomFactory.sharedInstance.makeRoom(at: mapSpot, width: 8, height: 2)
        case 5:
            room = RoomFactory.sharedInstance.makeRoom(at: mapSpot, width: 2, height: 4)
        case 6:
            room = RoomFactory.sharedInstance.makeRoom(at: mapSpot, width: 4, height: 4)
        case 7:
            room = RoomFactory.sharedInstance.makeRoom(at: mapSpot, width: 4, height: 4)
        case 8:
            
            //special???
            room = RoomFactory.sharedInstance.makeRoom(at: mapSpot, width: 5, height: 3)
            
        case 9, 10:
            
            //hall of stairs
            map.setBlock(at: mapSpot, block: MapBlock(tileCode: .passage, fromPassage: Passage(type: .hallway, direction: .north)))
            
            //crossroad
            mapSpot += MapPoint(row: 1, col: 0)
            map.setBlock(at: mapSpot, block: MapBlock(tileCode: .turnRight, fromPassage: Passage(type: .hallway, direction: .north)))
            
            //Hall to right
            var passage = Passage(type: .hallway, direction: .east)
            map.setBlock(at: MapPoint(row: mapSpot.row, col: mapSpot.col + 1), block: MapBlock(tileCode: .passage, fromPassage: passage))
            addToQueue(from: MapPoint(row: mapSpot.row, col: mapSpot.col + 1), passage: passage)
            
            //Hall to left
            passage = Passage(type: .hallway, direction: .west)
            map.getBlock(mapSpot).addCode(exit: Passage(type: .hallway, direction: .west))
            
            map.setBlock(at: MapPoint(row: mapSpot.row, col: mapSpot.col - 1), block: MapBlock(tileCode: .passage, fromPassage: passage))
            addToQueue(from: MapPoint(row: mapSpot.row, col: mapSpot.col - 1), passage: passage)
            
            if (roll == 10) {
                //Hall North
                passage = Passage(type: .hallway, direction: .north)
                map.getBlock(mapSpot).addCode(exit: Passage(type: .hallway, direction: .north))
                map.setBlock(at: MapPoint(row: mapSpot.row + 1, col: mapSpot.col), block: MapBlock(tileCode: .passage, fromPassage: passage))
                addToQueue(from: MapPoint(row: mapSpot.row + 1, col: mapSpot.col), passage: passage)
            }
            
            return
        default: //error?:
            room = RoomFactory.sharedInstance.makeRoom(at: mapSpot, width: 4, height: 4)
        }
        
        
        //Set Special so we don't have a mob in starting room:
        room.hasSpecial = true
        
        let entrancePoint = MapPoint(row: 0, col: Int(room.width / 2))
        
        room.setExit(at: entrancePoint, exit: Passage(type: .stairsUp, direction: .south))
        
        room.at -= entrancePoint
        
        if (roll <= 8) {
            
            let pType = (DGRand.sharedInstance.shuffle(array: passageTypes))
            
            var at = MapPoint(row: Int(room.height / 2), col: room.width - 1)
            var exit = Passage(type: pType[0] as! PassageType, direction: .east)
            
            room.setExit(at: at, exit: exit)
            addToQueue(from: room.at + at, passage: exit)
            
            at = MapPoint(row: Int(room.height / 2), col: 0)
            exit = Passage(type: pType[1] as! PassageType, direction: .west)
            room.setExit(at: at, exit: exit)
            addToQueue(from: room.at + at, passage: exit)
            
            if (roll == 4) {
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
    func generateRoom(from: MapPoint, entrance: Passage) {
        
        //Get a random sized room
        var tries = 10
        while tries > 0 {
            
            let room = RoomFactory.sharedInstance.makeRoom(at: from + getMoveVector(dir: entrance.direction))   //Todo fix up we don't need the at here
            
            
            if (placeRoom(room: room, entrance: entrance)) {
                return
            }
            tries -= 1
            
        }
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
        if (map.offScreen(ptLL: room.at, ptUR: room.at + MapPoint(row: room.height - 1, col: room.width - 1))) {
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
                map.mapBlocks[r][c] = room.floorBlocks[r - startPt.row][c - startPt.col]
            }
        }
        
        map.rooms.append(room)
        room.id = map.rooms.count
    }
    
    
    //MARK: Fixup
    // This will walk through all map spots to make sure we close off dead ends, generate Passage types, and make sure both blocks contain new Passage
    
    func fixUpMap() {
        
        var blockThis: MapBlock
        var blockThat: MapBlock

        //Pass 1: make sure all blocks match edge
        for r in (0..<map.mapBlocks.count) {
            for c in 0..<map.mapBlocks[r].count  {
            
                fixMatchBlock(blockAt: MapPoint(row: r, col: c), dir: Direction.north)
                fixMatchBlock(blockAt: MapPoint(row: r, col: c), dir: Direction.east)
            }
        }

        
        //trimAllDeadEnds() {
        //Pass 2: go through all tiles to find dead ends; when found, walk back the passage until we get to a room or branch, walling it up along the way
        
        for r in (0..<map.mapBlocks.count) {
            for c in 0..<map.mapBlocks[r].count  {
                
                
                if (map.getBlock(row: r, col: c).tileCode != .stairsUp && map.getBlock(row: r, col: c).tileCode != .stairsDown) {
                    //Now check for and walk back dead ends:
                    //let block = mapBlocks[r][c].getBlock()
                    let wallCount = map.getBlock(row: r, col: c).wallString.filter { $0 == "W" }.count // case-sensitive
                    
                    if (wallCount == 3) {
                        
                        if (DGRand.sharedInstance.getRand(to: 20) != 1) { //5% chance of keeping the deadend
                            trimDeadEnd(at: MapPoint(row: r, col: c))
                        } else {
                            print("keeping deadend")
                        }
                    }
                }
            }
        }
        
        //Populate doors:
        
        for r in (0..<map.mapBlocks.count) {
            for c in 0..<map.mapBlocks[r].count  {
                
                blockThis = map.getBlock(row: r, col: c)
                blockThat = map.getBlock(row: r+1, col: c)
        //If N is door, check to see if passage and if so, assign to S if not the same. Note that we don't have to check both since we've already fixed to match the S wall code
                if (blockThis.getWallCode(wallDir: .north) == "D" || blockThis.getWallCode(wallDir: .north) == "S") {
                    assert(blockThat.getWallCode(wallDir: .south) == "D" || blockThis.getWallCode(wallDir: .south) == "S")
                    var p = blockThis.getDoor(dir: .north)

                    if (p.type == PassageType.hallway) {
                        p = GetRandomDoor()
                        if (p.secret) {
                            blockThis.addCode(codeDir: .north, code: "S")
                            blockThat.addCode(codeDir: .south, code: "S")
                        }
                        blockThis.addDoor(dir: .north, passage: p)
                        blockThat.addDoor(dir: .south, passage: p)
                        
                    }
                }
                
                blockThat = map.getBlock(row: r, col: c+1)
                
                //If E is door, check to see if passage and if so, assign to W if not the same. Note that we don't have to check both since we've already fixed to match the W wall code
                if (blockThis.getWallCode(wallDir: .east) == "D" || blockThis.getWallCode(wallDir: .east) == "S") {
                    assert(blockThat.getWallCode(wallDir: .west) == "D" || blockThat.getWallCode(wallDir: .west) == "S")
                    var p = blockThis.getDoor(dir: .east)
                    if (p.type == PassageType.hallway) {
                        p = GetRandomDoor()
                        if (p.secret) {
                            blockThis.addCode(codeDir: .east, code: "S")
                            blockThat.addCode(codeDir: .west, code: "S")
                        }
                        blockThis.addDoor(dir: .east, passage: p)
                        blockThat.addDoor(dir: .west, passage: p)
                        
                    }
                }
            }
        }
    }
    
    func fixMatchBlock(blockAt: MapPoint, dir: Direction) {
        
        var codeThis : Character
        var codeThat : Character
        var blockThis: MapBlock

        blockThis = map.getBlock(blockAt)
        if let blockThat = map.getBlock(at: blockAt, dir: dir) {
            codeThis = blockThis.getWallCode(wallDir: dir)
            codeThat = blockThat.getWallCode(wallDir: dir.opposite())
            
            if (codeThis != codeThat && String([codeThis,codeThat]) != "0W" && String([codeThis,codeThat]) != "W0"  && codeThis != "+" && codeThat != "+" && codeThis != "-" && codeThat != "-") {
                if (["DP", "PD"].contains(String([codeThis, codeThat]))) { //Door on one side, hall on other = Door
                    blockThat.addCode(codeDir: dir.opposite(), code: "D")
                    blockThis.addCode(codeDir: dir, code: "D")
                } else if (["SP", "PS"].contains(String([codeThis, codeThat]))) { //secret on one side, hall on other = Secret
                    blockThat.addCode(codeDir: dir.opposite(), code: "S")
                    blockThis.addCode(codeDir: dir, code: "S")
                } else if (codeThis == "0") { //Wall off doors/passages to nowhere
                    blockThat.addWall(wallDir: dir.opposite())
                } else if (codeThat == "0") {
                    blockThis.addWall(wallDir: dir)
                } else {
                    //pick one to be authority:
                    if (DGRand.sharedInstance.getRand(to: 2) == 2) {
                        blockThat.addCode(codeDir: dir.opposite(), code: codeThis)
                        
                    } else  {
                        blockThis.addCode(codeDir: dir, code: codeThat)
                    }
                }
            }
            
        } else {
            //blockThat is null therefore wall off this direction
            blockThis.addWall(wallDir: dir)
        }
        
    }
    
    func trimDeadEnd(at: MapPoint) {
        //Call this at a dead end, walk backwards erasing the passage until we get to a non-hall block
        
        //I'm moving to the Dir direction, looking for walls to edges, and if so, blank it out
        var curPt = at
        var move : MapPoint
        var curDir : Direction
        //print ("Start")
        while (!map.offScreen(point: curPt)) {
            
            
            let block = map.getBlock(curPt)
            
            
            let wallCount = block.wallString.filter { $0 == "W" }.count // case-sensitive
            //print ("Wallstring is \(block.wallString), count W = \(wallCount) at \(curPt)")
            
            if (wallCount == 3) {
                let chars = Array(block.wallString)
                
                //Check to see where the exit is:
                if (chars[0] != "W") {
                    move = getMoveVector(dir: .north)
                    curDir = .north
                } else if (chars[1] != "W") {
                    move = getMoveVector(dir: .east)
                    curDir = .east
                } else if (chars[2] != "W") {
                    move = getMoveVector(dir: .south)
                    curDir = .south
                } else { //if (chars[3] != "W") {
                    move = getMoveVector(dir: .west)
                    curDir = .west
                }
                
                //wipe
                map.setBlock(at: curPt, block: MapBlock())
                
                //Move back down passage
                curPt += move
                
                //Wall it off:
                map.getBlock(curPt).addWall(wallDir: curDir.opposite())
                
                
            } else {
                return
            }
        }
        
    }
    
    
    //MARK: Helpers
    
    func doesOverlap(room: Room) -> Bool {
        for r in 0...(room.height - 1) {
            let rm = r + room.at.row
            for c in 0...(room.width - 1) {
                let cm = c + room.at.col
                if (map.getBlock(row: rm, col: cm).tileCode != TileCode.null) {
                    //if (floor[rm][cm] > 0) {
                    //print("Overlap at r:c \(rm):\(cm)")
                    return true
                }
            }
        }
        return false
    }
    
}
