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
    
    
    func addOverlay(text: String, at: CGPoint) {

            
        let myLabel = SKLabelNode()
        myLabel.text = text
        myLabel.fontColor = .red
        myLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        myLabel.fontSize = 100

        
        myLabel.position = at
        
        self.renderLayer.addChild(myLabel)
    }
    
    
    
}
