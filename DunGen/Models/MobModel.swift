//
//  MobModel.swift
//  DunGen
//
//  Created by Richard Moe on 5/10/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation
import SpriteKit


class Mob : ObservableObject {
    
    
    let uid:UUID?
    
    var name: String

    
    var armorClass: Int
    @Published var hitPoints: Int
    var maxHitPoints: Int
    
    var image: String  //for now, an image
    
    var initiativeBonus = 0
    
    var sprite : SKSpriteNode?
    
    var currentTarget : Mob? //For battle
    
    init(name: String, armorClass: Int, hitPoints: Int, initiativeBonus: Int, image: String)
    {
        self.uid = UUID()
        self.name = name
        self.armorClass = armorClass
        self.hitPoints = hitPoints
        self.maxHitPoints = hitPoints
        self.image = image
        self.initiativeBonus = initiativeBonus
        
    }
    
    func decreaseHP() {
        hitPoints -= 1
        hitPoints = max(hitPoints, 0)
    }
    
    func increaseHP() {
        hitPoints += 1
        hitPoints = min(hitPoints, maxHitPoints)
    }
    
    func instantiateSprite(at: CGPoint) -> SKSpriteNode {
        
        let s  = SKSpriteNode(imageNamed: image)
        s.name = name
        s.setScale(0.5)
        s.position = at
        sprite = s
        return s
    }
    
    func move(toPt: CGPoint) {
        let mv = SKAction.move(to: toPt, duration: 0.5 + (Double.random(in: -0.05...0.05)))
        Global.isMoving = true
        if let s = sprite {
            s.run(mv) {
                //is moving = false
                Global.isMoving = false
            }
        }
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
    
}
