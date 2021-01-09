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
    var battleOverlayLayer: SKTileMapNode!
    
    var debugLayer: SKTileMapNode!
    var debugOverlayLayer: SKTileMapNode!
    
    var debugOverlayTextLayer: DebugOverlay!
    
    var tileDict = [Int: Int]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    var mapController : MapController?
    private var battleController : BattleController?
    
    var debugLayerOn = false
    
    var cameraOffset = 200.0
    var currentScale : CGFloat = 1.0
    
     var cameraIsMoving = false

    
    /* Gesture recognizer
    
    func loadTaphandler() {
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.view!.addGestureRecognizer(doubleTapGestureRecognizer)
        

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        self.view!.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func handleTapGesture(sender: UITapGestureRecognizer) {
//            let touchPoint = sender.location(in: tableView)
//            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
//                print(indexPath)
//            }
        
        let touchPoint = sender.location(in: self.view!)
        let sceneLocation = convertPoint(fromView: touchPoint)
        

        if (Global.adventure.inBattle == true) {

            if let bc = Global.adventure.currentBattle {
                bc.clickAt(sceneLocation)
            }
        } else {

            if let mc = mapController {
                mc.clickAt(sceneLocation)
            }

        }
        print ("Single tap at \(touchPoint) - scene: \(sceneLocation)")
    }

    @objc func handleDoubleTap(sender: UITapGestureRecognizer) {
//        let touchPoint = sender.location(in: tableView)
//        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
//            print(indexPath)
//        }
        print ("double tap")
    }
    
    override func didMove(to view: SKView) {
        print("didMove - running")
                loadTaphandler()
    }

    end gesture recognizer */
    
    override func sceneDidLoad() {
        

        self.lastUpdateTime = 0
        guard let backgroundLayer = childNode(withName: "Background") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        
        
        guard let camera = self.childNode(withName: "GameCamera") as? SKCameraNode else {
            fatalError("Camera node not loaded")
        }
        
        self.backgroundLayer = backgroundLayer
        
        
        createMapLayer()
        
        
        self.camera = camera
        
        
        //self.camera!.setScale(3.5)
        
        print("----------------------creating players---------------")
        Global.party.createParty()
        
        Global.party.initAvatars(onLayer: self)
        
        Global.adventure.dungeon.buildDungeon()
        
        mapController = MapController(dungeon: Global.adventure.dungeon, tileMap: self.mapLayer)
        mapController!.placeParty()
        


        
        
    }
    
    func initBattle(encounter: Encounter) {
        
        let battle = BattleController(encounter: encounter, map: Global.adventure.dungeon.currentLevel(), tileMap: self.mapLayer)
        Global.adventure.currentBattle = battle
        battleController = battle
        
        Global.adventure.inBattle = true
        
        
        createBattleOverlay()
    }
    
    func tempEncounter () -> Encounter {
        
        //Temp
        let enc = Encounter(at: MapPoint(row: 3, col: 13))
        //enc.initMobSprites(dungeon: self)
        
        return enc
    }
    
    
    func endBattle() {
        
        
        Global.adventure.currentBattle = nil
        if let b = self.battleController {
            if let h = b.highlightSprite {
                h.removeFromParent()
                
            }
        }
        battleController = nil
        Global.adventure.inBattle = false
        
        self.battleOverlayLayer.isHidden = true
    }
    
    
    func createMapLayer() {
        
        let size = CGSize(width: MapTileSet.tileWidth, height: MapTileSet.tileHeight)
        
        self.mapLayer = SKTileMapNode(tileSet: Global.mapTileSet.tileSet, columns: Global.adventure.dungeon.mapWidth, rows: Global.adventure.dungeon.mapHeight, tileSize: size)
        backgroundLayer.addChild(mapLayer)
    }
    
    func createBattleOverlay() {
        
        let size = CGSize(width: 64, height: 64)
        
        self.battleOverlayLayer = SKTileMapNode(tileSet: Global.mapTileSet.tileSet, columns: Global.adventure.dungeon.mapWidth * 2, rows: Global.adventure.dungeon.mapHeight * 2, tileSize: size)
        backgroundLayer.addChild(battleOverlayLayer)
        
        Global.mapTileSet.createBattleOverlayTile()
        
        if let groupIx = Global.mapTileSet.tileDict["BATTLE_OVERLAY"] {
            //print ("rendering tile \(tile.wallString): \(groupIx) at c/R: \(col), \(row)")
            battleOverlayLayer.fill(with: mapLayer.tileSet.tileGroups[groupIx])
        }
    }
    
    func createDebugLayer() {
        
        debugLayerOn = true
        
        Global.mapTileSet.createDebugTiles()
        
        let size = CGSize(width: MapTileSet.tileWidth, height: MapTileSet.tileHeight)
        
        self.debugLayer = SKTileMapNode(tileSet: Global.mapTileSet.tileSet, columns: Global.adventure.dungeon.mapWidth, rows: Global.adventure.dungeon.mapHeight, tileSize: size)
        backgroundLayer.addChild(debugLayer)
        
        self.debugOverlayLayer = SKTileMapNode(tileSet: Global.mapTileSet.tileSet, columns: Global.adventure.dungeon.mapWidth, rows: Global.adventure.dungeon.mapHeight, tileSize: size)
        backgroundLayer.addChild(debugOverlayLayer)
        
        if let m = mapController {
            m.renderDebugMap(layer: debugLayer, overlay: debugOverlayLayer)
        }
        
        
        debugOverlayTextLayer = DebugOverlay(layer: debugOverlayLayer)
        debugOverlayTextLayer.roomNumberOverlays()
        
        debugOverlayTextLayer.renderDoors()
        debugOverlayTextLayer.renderMapCodes()
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
        //            self.addChild(na
        //        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        print ("TouchUp pos: \(pos)")
        if (Global.adventure.inBattle == true) {

            if let bc = Global.adventure.currentBattle {
                bc.clickAt(pos)
            }
        } else {

            if let mc = mapController {
                mc.clickAt(pos)
            }

        }
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
        
        print ("---")
        for t in touches {
            print ("TapCount: \(t.tapCount)")
            self.touchUp(atPoint: t.location(in: self))
            
        }
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
        
        //let movePt = backgroundLayer.centerOfTile(atColumn: Global.adventure.party.at.col, row: Global.adventure.party.at.row)
        //let moveMap = Global.adventure.party.mapPt()

        
        
        if let b = Global.adventure.currentBattle {
            if let h = b.highlightSprite {
                h.position = b.currentAt()
                if (!cameraIsMoving && camera!.position != h.position) {
                    cameraMove(toPt: h.position)
                }
                //camera!.position = h.position
            }
            if let s = b.targetSprite {
                if let pt = b.currentTargetAt() {
                    s.isHidden = false
                    s.position = pt
                } else {
                    s.isHidden = true
                }
            }
            
        } else {
            //Map Controller
            if let p = Global.party.player[0].sprite {
                camera!.position = (p.position + CGPoint(x: 0.0, y: cameraOffset / Double(currentScale)))
            }
        }
        
        self.lastUpdateTime = currentTime
    }
    
    func clickButton(name: String) {
        
        print ("Clicked button \(name)")
        
        //
        switch name {
        case "BATTLE":
            if (Global.adventure.inBattle) {
                endBattle()
            } else {
                initBattle(encounter: tempEncounter())
            }
        case "ZOOM":
            //toggle zoom here:
            if (currentScale != 1.0) {
                currentScale = 1.0
                camera!.setScale(currentScale)
            } else {
                scaleToFit()
            }
        case "DEBUGMAP":
            //toggle map debug:
            //debug layer?
            print("DB")
            if let d = debugLayer {
                debugLayerOn = !debugLayerOn
                
                d.isHidden = !debugLayerOn
                if let dOL = debugOverlayLayer {
                    dOL.isHidden = !debugLayerOn
                }
                
            } else {
                createDebugLayer()
            }
            
        default:
            print("No action")
        }
        
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
    
    func cameraMove(toPt: CGPoint) {
        
        let mv = SKAction.move(to: toPt, duration: 0.5)
        cameraIsMoving = true
        if let c = camera {
            c.run(mv) {
                //is moving = false
                self.cameraIsMoving = false
            }
        }
    }
    
    //
    //    func testRebuildMap() {
    //
    //        mapController.rebuild()
    //
    //
    //        mapLayer.removeFromParent()
    //
    //        let size = CGSize(width: MapTileSet.tileWidth, height: MapTileSet.tileHeight)
    //
    //        self.mapLayer = SKTileMapNode(tileSet: mapTileSet.tileSet, columns: mapController.mapWidth, rows: mapController.mapHeight, tileSize: size)
    //        backgroundLayer.addChild(mapLayer)
    //
    //        renderMap()
    //
    //        if (debugLayerOn) {
    //            debugLayer.removeFromParent()
    //            createDebugLayer()
    //        }
    //    }
    //
    
}
