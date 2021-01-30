//
//  DropModel.swift
//  DunGen
//
//  Created by Richard Moe on 7/12/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation
import SpriteKit



class Drop {
    
    //type:
    // TOMBSTONE
    // CHEST
    var type : Int
    var locked: Bool = false
    var trapped: Bool = false
    
    let uid:UUID
    
    let name: String
    var sprite : SKSpriteNode?
    let loot: Loot
    
    
    init(type: Int, name: String, loot: Loot)
    {
        self.uid = UUID()
        self.type = type
        
        self.name = name
        
        self.loot = loot
    }
    
    
    func instantiateSprite(at: CGPoint) -> SKSpriteNode {
        
        let image: String
        if (type == 1) {
            image = "tombstone.png"
        } else {
            if (type == 2) {
                image = "treasureChest128.png"
            } else {
                image = "tombstone.png"
            }
        }
        
        let s  = SKSpriteNode(imageNamed: image)
        s.name = name
        if (type == 1) {
            s.setScale(0.25)
        } else {
            if (type == 2) {
                s.setScale(0.5)
            }
        }
        s.position = at
        s.zPosition = Global.zPosDrop
        sprite = s
        return s
    }
    
    func at(_ atPt: CGPoint) {
        if let s = sprite {
            s.position = atPt
        }
    }
    
    func at() -> CGPoint {
        
        if let s = sprite {
            return s.position
        } else {
            return CGPoint(x: 0, y: 0)
        }
    }
    
    func getLoot() -> Loot{
        print("Getting loot")
        print(loot.toString())
        
       return loot
        
        
    }

}
