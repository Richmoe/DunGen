//
//  DungeonScene.swift
//  AdventureDungeon
//
//  Created by Richard Moe on 4/4/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import SpriteKit
import GameplayKit

class DungeonScene: SKScene {
    
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var backgroundLayer: SKTileMapNode!
    
    var mapLayer: SKTileMapNode!
    
    var debugLayer: SKTileMapNode!
    
    
    var tileDict = [Int: Int]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    private var map: Map = Map()
    
    
    private var mapTileSet = MapTileSet()
    
    var party = Party()
    
    var debugLayerOn = false
    
    let cameraOffset = 0.0
    var currentScale : CGFloat = 1.0
    
    let maxLineOfSight = 6 //Can see 60' or 6 10x10 tiles
    
    
    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0
        guard let backgroundLayer = childNode(withName: "Background") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        
        
        guard let camera = self.childNode(withName: "GameCamera") as? SKCameraNode else {
            fatalError("Camera node not loaded")
        }
        
        self.backgroundLayer = backgroundLayer
        
        createAndRenderMap()
        self.camera = camera
        
        scaleToFit()
        
        //self.camera!.setScale(0.25)
        createPlayers()
        
        goToTile(map.entranceLanding)
        
        //createDebugLayer()
        
        fogOfWar()
    }
    
    func createPlayers() {
        
        
        var p1 = Player(name: "Cherrydale", level: 1, experience: 0, armorClass: 6, hitPoints: 8, avatar: "TestAvatar")
        
        party.addPlayer(p1)
        
        p1 = Player(name: "Tomalot", level: 1, experience: 0, armorClass: 6, hitPoints: 8, avatar: "TestAvatar")
        party.addPlayer(p1)
        
        p1 = Player(name: "Svenwolf", level: 1, experience: 0, armorClass: 6, hitPoints: 8, avatar: "TestAvatar")
        party.addPlayer(p1)
        
        p1 = Player(name: "Sookie", level: 1, experience: 0, armorClass: 6, hitPoints: 8, avatar: "TestAvatar")
        party.addPlayer(p1)
        
        party.initAvatars(onLayer: self)
        
        
    }
    
    
    func createAndRenderMap() {
        
        let size = CGSize(width: MapTileSet.tileWidth, height: MapTileSet.tileHeight)
        
        self.mapLayer = SKTileMapNode(tileSet: mapTileSet.tileSet, columns: map.mapWidth, rows: map.mapHeight, tileSize: size)
        backgroundLayer.addChild(mapLayer)
        
       //renderMap(map: map)
        
    }
    
    func fogOfWar() {
        //input new position
        
        for a in 0...59 { //6deg increments
            let ang = 6 * Double(a)
            let x = sin(ang  * (.pi / 180))
            let y = cos(ang * (.pi / 180))
            var fromPt = party.at
            var lastXx = 0
            var lastYy = 0
            
            for i in 1...maxLineOfSight {
                let xx = Int(round(x * Double(i)))
                let yy = Int(round(y * Double(i)))
                if (xx != 0 || yy != 0) {
                    
                    let moveVector = MapPoint(row: yy - lastYy, col: xx - lastXx)
                    
                    lastXx = xx
                    lastYy = yy
                    
                    let toPt = fromPt + moveVector
                    
                    if (map.canSee(from: fromPt, to: toPt)) {
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
    
    func createDebugLayer() {
        
        debugLayerOn = true
        mapTileSet.createDebugTiles()
        
        let size = CGSize(width: MapTileSet.tileWidth, height: MapTileSet.tileHeight)
        
        debugLayer = SKTileMapNode(tileSet: mapTileSet.tileSet, columns: map.mapWidth, rows: map.mapHeight, tileSize: size)
        backgroundLayer.addChild(debugLayer)
        
        for row in 0..<map.mapBlocks.count {
            for col in (0..<map.mapBlocks[row].count) {
                
                let tileBlock = (map.mapBlocks[row][col])
                if (tileBlock.tileCode == TileCode.floor) {
                    
                    renderTile(layer: debugLayer, code: "DEBUG_ROOM", col: col, row: row)
                }
                
                //Secret will override:
                if (tileBlock.wallString.contains("S")) {
                    renderTile(layer: debugLayer, code: "Sxxx", col: col, row: row)
                }
                
            }
        }
        
    }
    
    func testRebuildMap() {
        map = Map()
        
        mapLayer.removeFromParent()
        
        let size = CGSize(width: MapTileSet.tileWidth, height: MapTileSet.tileHeight)
        
        self.mapLayer = SKTileMapNode(tileSet: mapTileSet.tileSet, columns: map.mapWidth, rows: map.mapHeight, tileSize: size)
        backgroundLayer.addChild(mapLayer)
        
        renderMap(map: map)
        
        if (debugLayerOn) {
            debugLayer.removeFromParent()
            createDebugLayer()
        }
    }
    
    
    func renderMap (map: Map) {
        
        for row in 0..<map.mapBlocks.count {
            for col in (0..<map.mapBlocks[row].count) {
                
                //let tileBlock = (map.mapBlocks[row][col])
                
                //renderTile(tile: tileBlock, col: col, row: row)
                renderTile(MapPoint(row: row, col: col))
                
            }
        }
    }
    
    func renderTile(layer: SKTileMapNode, code: String, col: Int, row: Int) {
        //replace
        if let groupIx = mapTileSet.tileDict[code] {
            //print ("rendering tile \(tile.wallString): \(groupIx) at c/R: \(col), \(row)")
            layer.setTileGroup(mapLayer.tileSet.tileGroups[groupIx], forColumn: col, row: row)
        } else {
            if (code != "0000") {
                print ("Can't find tile: \(code) at rc: \(row), \(col)")
            }
        }
        
    }
    
    func renderTile(tile: MapBlock, col: Int, row: Int) {
        
        //replace 
        if let groupIx = mapTileSet.tileDict[tile.wallString] {
            //print ("rendering tile \(tile.wallString): \(groupIx) at c/R: \(col), \(row)")
            mapLayer.setTileGroup(mapLayer.tileSet.tileGroups[groupIx], forColumn: col, row: row)
        } else {
            if (tile.wallString != "0000") {
                print ("Can't find tile: \(tile.wallString) at rc: \(row), \(col)")
            }
        }
    }
    
    func renderTile(_ mp: MapPoint) {
        
        let mb = map.getBlock(mp)
        if let groupIx = mapTileSet.tileDict[mb.wallString] {
            //print ("rendering tile \(tile.wallString): \(groupIx) at c/R: \(col), \(row)")
            mapLayer.setTileGroup(mapLayer.tileSet.tileGroups[groupIx], forColumn: mp.col, row: mp.row)
        } else {
            if (mb.wallString != "0000") {
                print ("Can't find tile: \(mb.wallString) at rc: \(mp.row), \(mp.col)")
            }
        }
    }
    
    
    
    func touchDown(atPoint pos : CGPoint) {
        //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        //            n.position = pos
        //            n.strokeColor = SKColor.green
        //            self.addChild(n)
        //        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        //            n.position = pos
        //            n.strokeColor = SKColor.blue
        //            self.addChild(n)
        //        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        //        map.nextInQueue()
        //        renderMap(map: map)
        
        
        let partyAt = backgroundLayer.centerOfTile(atColumn: party.at.col, row: party.at.row)
        
        let norm = normalize(pt: pos - partyAt) //- camera!.position)
        
        moveDir(dirPt: norm)
        //
        //        let tileR = backgroundLayer.tileRowIndex(fromPosition: pos)
        //        let tileC = backgroundLayer.tileColumnIndex(fromPosition: pos)
        //        print ("Click on tile: \(tileC), \(tileR)")
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        if let label = self.label {
        //            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        //        }
        //
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        let movePt = backgroundLayer.centerOfTile(atColumn: party.at.col, row: party.at.row)
        camera!.position = (movePt + CGPoint(x: 0.0, y: cameraOffset / Double(currentScale)))
        
        
        
        self.lastUpdateTime = currentTime
    }
    
    
    func moveDir(dirPt: CGPoint) {
        
        //Round the vector to get nice even numbers:
        let dx: Int = Int(dirPt.x.rounded())
        let dy: Int = Int(dirPt.y.rounded())
        
        move(from: party.at, dir: getDirFromVector(MapPoint(row: dy, col: dx)))
        
    }
    
    
    func move(from: MapPoint, dir: Direction) {
        
        //first check to see if we can move
        let (canMove, newSpot) = map.move(from: from, dir: dir)
        
        //Then rerender map?
        if (canMove) {
            
            //Do the move
            let movePt = backgroundLayer.centerOfTile(atColumn: newSpot.col, row: newSpot.row)
            print ("moveToTile: \(newSpot.col), \(newSpot.row): \(movePt), offset: \(cameraOffset / Double(currentScale))")
            
            party.renderParty(atPt: movePt, atTile: MapPoint(row: newSpot.row, col: newSpot.col))
            
            //just in case:
            renderTile(newSpot)

            fogOfWar()
        }
        
        
    }
    
    func goToTile(_ tile: MapPoint) {
        let movePt = backgroundLayer.centerOfTile(atColumn: tile.col, row: tile.row)
        print ("goToTile: \(tile.col), \(tile.row): \(movePt), offset: \(cameraOffset / Double(currentScale))")
        
        party.renderParty(atPt: movePt, atTile: MapPoint(row: tile.row, col: tile.col))
        
        renderTile(tile)
    }
    
    
    func scaleToFit() {
        
        let w = self.size.width
        let h = self.size.height
        
        let mw = self.backgroundLayer.mapSize.width
        let mh = self.backgroundLayer.mapSize.height
        
        let scale  = CGFloat(min( (w/mw), (h/mh)))
        
        print("scaleToFit() : w,h: \(w), \(h); MapSize: \(mw),\(mh)")
        
        
        camera!.setScale(1/scale)
        
        currentScale = CGFloat( scale)
        
        print ("Scaling to \(scale) , \(currentScale)")
    }
    
}
