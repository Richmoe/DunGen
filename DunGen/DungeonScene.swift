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
    
    private var mapBaseLayer = [[MapBlock]]()
    private var mapTileSet = MapTileSet()
    
    var player1: SKSpriteNode!
    
    var debugLayerOn = false
    
    
    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0
        guard let backgroundLayer = childNode(withName: "Background") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        
        //        guard let dungeonLayer = backgroundLayer.childNode(withName: "Dungeon") as? SKTileMapNode else {
        //            fatalError("Background node not loaded")
        //        }
        
        
        //map.printFloor()
        
        
        //        guard let gridLayer = childNode(withName: "grid") as? SKTileMapNode else {
        //            fatalError("Grid node not loaded")
        //        }
        //
        //        guard let selectionLayer = childNode(withName: "selection") as? SKTileMapNode else {
        //            fatalError("Selection node not loaded")
        //        }
        //
        guard let camera = self.childNode(withName: "GameCamera") as? SKCameraNode else {
            fatalError("Camera node not loaded")
        }
        
        self.backgroundLayer = backgroundLayer

        createAndRenderMap()
        self.camera = camera
        
        scaleToFit()
        
        //self.camera!.setScale(0.25)
        createPlayers()
        
        moveToTile(map.entrance)
        
        createDebugLayer()
        
        
    }
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "TestAvatar")
        player1.name = "Test"
        
        
        let pos = getPtFromTilePt(map.entranceLanding)
        player1.position = pos
        addChild(player1)
    }
    
    
    func createAndRenderMap() {
        
        let size = CGSize(width: MapTileSet.tileWidth, height: MapTileSet.tileHeight)
        
        self.mapLayer = SKTileMapNode(tileSet: mapTileSet.tileSet, columns: map.mapWidth, rows: map.mapHeight, tileSize: size)
        backgroundLayer.addChild(mapLayer)
        
        renderMap(map: map)
        
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
                
                let tileBlock = (map.mapBlocks[row][col])
                
                renderTile(tile: tileBlock, col: col, row: row)
                
                
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
    
    func renderTile(tile: Int, col: Int, row: Int) {
        
        if let groupIx = tileDict[tile] {
            mapLayer.setTileGroup(mapLayer.tileSet.tileGroups[groupIx], forColumn: col, row: row)
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
        //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        //            n.position = pos
        //            n.strokeColor = SKColor.red
        //            self.addChild(n)
        //        }
        
        #if false
        map.nextInQueue()
        renderMap(map: map)
        #else
        print("---")
        print ("TouchUp: \(pos)")
        
        print("Camera was at: \(camera!.position)")
        
        //        let delta = CGPoint(x: pos.x - cameraNode!.position.x, y: pos.y - cameraNode!.position.y)
        //        print ("Delta: \(delta)")
        let norm = normalize(pt: pos - camera!.position)
        //        moveDir(dv: normalize(pt: delta))
        //
        moveDir(dirPt: norm)
        
        let tileR = backgroundLayer.tileRowIndex(fromPosition: pos)
        let tileC = backgroundLayer.tileColumnIndex(fromPosition: pos)
        print ("Click on tile: \(tileC), \(tileR)")
        
        let tileDef : SKTileDefinition! = backgroundLayer.tileDefinition(atColumn: tileC, row: tileR)
        
        print("TileDef: \(tileDef)")
        //moveToTile(col: tileC, row: tileR)
        
        //
        //scaleToFit()
        #endif
        
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
        
        self.lastUpdateTime = currentTime
    }
    
    
    func moveDir(dirPt: CGPoint) {
        
        //Round the vector to get nice even numbers:
        let dx: Int = Int(dirPt.x.rounded())
        let dy: Int = Int(dirPt.y.rounded())
        
        //get current tile
        let tR = backgroundLayer.tileRowIndex(fromPosition: camera!.position)
        let tC = backgroundLayer.tileColumnIndex(fromPosition: camera!.position)
        
        moveToTile(col: tC + dx, row: tR + dy)
    }
    
    
    func moveToTile(col: Int, row: Int) {
        let movePt = backgroundLayer.centerOfTile(atColumn: col, row: row)
        print ("moveToTile: \(col), \(row): \(movePt)")
        camera!.position = movePt
    }
    
    
    func moveToTile(_ tile: MapPoint) {
        let movePt = backgroundLayer.centerOfTile(atColumn: tile.col, row: tile.row)
        print ("moveToTile: \(tile.col), \(tile.row): \(movePt)")
        camera!.position = movePt
    }
    
    func getPtFromTilePt(_ tile: MapPoint) -> CGPoint {
        let pt = backgroundLayer.centerOfTile(atColumn: tile.col, row: tile.row)
        return pt
        
    }
    
    func scaleToFit() {
        
        let w = self.size.width
        let h = self.size.height
        
        let mw = self.backgroundLayer.mapSize.width
        let mh = self.backgroundLayer.mapSize.height
        
        let scale  = CGFloat(min( (w/mw), (h/mh)))
        
        print("scaleToFit() : w,h: \(w), \(h); MapSize: \(mw),\(mh)")
        
        //self.backgroundLayer.xScale = scale
        //self.backgroundLayer.yScale = scale
        
        camera!.setScale(1/scale)
        
        print ("Scaling to \(scale)")
    }
    
    
    func getTileData(atCol: Int, row: Int) {
        let tileDef : SKTileDefinition! = mapLayer.tileDefinition(atColumn: atCol, row: row)
        if let userData = tileDef.userData {
            //get information from it here and do what we want
        }
    }
}
