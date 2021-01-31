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
            addOverlay(text: "R\(m.id)", at: pos)
        }

    }
   
    
    func renderMapCodes() {
        
        let map = Global.adventure.dungeon.currentLevel()
        for row in 0..<Global.adventure.dungeon.mapHeight {
            for col in 0..<Global.adventure.dungeon.mapWidth {
                
                var pos = map.MapPointToCGPoint(MapPoint(row: row, col: col))
               
                
                
                
                //map base
                let wallStr = map.getBlock(row: row, col: col).wallString
                for ix in 0...3 {
                
                        let offset: CGPoint
                        switch ix {
                        case 0:
                            offset = CGPoint(x: 50,y: 100)
                        case 1:
                            offset = CGPoint(x: 100, y: 60)
                        case 2:
                            offset = CGPoint(x: 50, y: 0)
                        default:
                            offset = CGPoint(x: 0, y: 60)
                        }
                        //pos += offset
                        

                    addOverlay(text: String(Array(wallStr)[ix]), at: pos + offset, size: 25.0, color: .red)
                }

            }
        }
    }
    
    func renderDoors() {
        
        let map = Global.adventure.dungeon.currentLevel()
        for row in 0..<Global.adventure.dungeon.mapHeight {
            for col in 0..<Global.adventure.dungeon.mapWidth {
                
                var pos = map.MapPointToCGPoint(MapPoint(row: row, col: col))
                //Debug tile:
                addOverlay(text: "\(row),\(col)", at: pos, size: 25)
                
                
                //map base
                let b = map.getBlock(row: row, col: col)
                
                if (b.encounter != nil) {
                    
                    addOverlay(text: "E", at: pos + CGPoint(x: 40, y: 40), size: 100, color: .green, bold: true)
                }
                
                if (b.treasure != nil) {
                    addOverlay(text: "$", at: pos + CGPoint(x:40, y:40), size: 100, color: .orange, bold: true)
                }
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
                        pos += offset
                        var text: String = "D"
                        if (b.passage[ix].locked) {
                            text = "L"
                        }
                        if (b.passage[ix].secret) {
                            text = "S"
                        }
                        addOverlay(text: text, at: pos, size: 75.0)
                    }
                }

            }
        }
    }

    
    func addOverlay(text: String, at: CGPoint, size: CGFloat = 100.0, color: UIColor = .blue, bold: Bool = false) {

            
        let myLabel = SKLabelNode()
        myLabel.text = text
        if (bold) {
            myLabel.fontName = "HelveticaNeue-Bold"
        }
        myLabel.fontColor = color
        myLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        myLabel.fontSize = size

        
        myLabel.position = at
        
        self.renderLayer.addChild(myLabel)
    }
    
    
    
}
