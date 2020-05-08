//
//  PartyModel.swift
//  DunGen
//
//  Created by Richard Moe on 5/3/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation
import SpriteKit

class Party {
    
    var player = [Player]()
    var at = MapPoint(row: 0, col: 0)
    
    var avatar = [SKSpriteNode]()
    
    let offset = 32
    

    func addPlayer(_ p : Player) {
        player.append(p)
    }
    
    func removePlayer(_ p: Player) {
        //TODO
    }
    
    func moveParty() {
        
    }
    
    func initAvatars(onLayer: SKScene) {
        for p in player {
            let a = SKSpriteNode(imageNamed: p.avatar)
            a.name = p.name
            a.setScale(0.5)
            
            onLayer.addChild(a)
            avatar.append(a)
        }
    }
    
    func renderParty(atPt: CGPoint, atTile: MapPoint) {
        at = atTile
        //Assume a grid of 64x64 and AT is the center
        //Assume max 4
        avatar[0].position = atPt + CGPoint(x: -offset, y: -offset)
        if (avatar.count > 1) {
            avatar[1].position = atPt + CGPoint(x: +offset, y: -offset)
            if (avatar.count > 2) {
                avatar[2].position = atPt + CGPoint(x: -offset, y: +offset)
                if (avatar.count > 3) {
                       avatar[3].position = atPt + CGPoint(x: +offset, y: +offset)
                }
            }
        }
        
    }
    
}
