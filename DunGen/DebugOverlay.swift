//
//  DebugOverlay.swift
//  DunGen
//
//  Created by Richard Moe on 1/2/21.
//  Copyright © 2021 Richard Moe. All rights reserved.
//

import SpriteKit


class DebugOverlay {
    
    var renderLayer: SKTileMapNode!
    
    var labelList: [SKLabelNode] = [SKLabelNode]()
    
    
    
    
    init(layer: SKTileMapNode) {
        
        renderLayer = layer
    }
    
    
    func roomNumberOverlays() {
        
        let map = Global.adventure.dungeon.currentLevel()
        for m in map.rooms {
            let atMap = m.at
            let pos = map.MapPointToCGPoint(atMap) + CGPoint(x: 10, y: 10)
            addOverlay(text: "R\(m.id)", at: pos, offset: CGPoint(x: 10, y: 10))
        }

    }
    
    
    func renderDoors() {
        
        let map = Global.adventure.dungeon.currentLevel()
        for row in 0..<Global.adventure.dungeon.mapHeight {
            for col in 0..<Global.adventure.dungeon.mapWidth {
                
                //map base
                let b = map.getBlock(row: row, col: col)
                for ix in 0...3 {
                
                    if (b.passage[ix].type != PassageType.hallway) {

                        let offset: CGPoint
                        switch ix {
                        case 0:
                            offset = CGPoint(x: 50,y: 100)
                        case 1:
                            offset = CGPoint(x: 100, y: 50)
                        case 2:
                            offset = CGPoint(x: 50, y: 0)
                        default:
                            offset = CGPoint(x: 0, y: 50)
                        }
                        let pos = map.MapPointToCGPoint(MapPoint(row: row, col: col)) + offset
                        var text: String = "D"
                        if (b.passage[ix].locked) {
                            text = "L"
                        }
                        if (b.passage[ix].secret) {
                            text = "S"
                        }
                        addOverlay(text: text, at: pos, size: 100.0)
                    }
                }

            }
        }
    }
    
    
    func addOverlay(text: String, at: CGPoint, size: CGFloat = 100.0, offset: CGPoint = CGPoint(x: 0, y: 0)) {

            
        let myLabel = SKLabelNode()
        myLabel.text = text
        myLabel.fontColor = .blue
        myLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        myLabel.fontSize = size

        
        myLabel.position = at
        
        self.renderLayer.addChild(myLabel)
    }
    
    
    
}
