//
//  PartyModel.swift
//  DunGen
//
//  Created by Richard Moe on 5/3/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftUI

class Party : ObservableObject {
    
    @Published var player = [Player]()
    @Published var at = MapPoint(row: 0, col: 0)
    
    var avatar = [SKSpriteNode]()
    
    let offset = 32
    

    func addPlayer(_ p : Player) {
        player.append(p)
    }
    
    func removePlayer(_ p: Player) {
        //TODO
    }

    func atPt() -> CGPoint {
        return avatar[0].position - getOffset(0)
    }
    
    func initAvatars(onLayer: SKScene) {
        for p in player {
            let a = SKSpriteNode(imageNamed: p.image)
            a.name = p.name
            a.setScale(0.5)
            
            onLayer.addChild(a)
            avatar.append(a)
        }
    }
    
    func setAt(atPt: CGPoint, atTile: MapPoint) {
        at = atTile
        for i in 0..<avatar.count {
            let pt = atPt + getOffset(i)
            avatar[i].position = pt
        }
        
    }
    
    func moveParty(toPt: CGPoint, toTile: MapPoint) {
        
        at = toTile
        
        for i in 0..<avatar.count {
            let mv = SKAction.move(to: toPt + getOffset(i), duration: 1.0 + (Double.random(in: -0.05...0.05)))
            avatar[i].run(mv) {
                //is moving = false
            }
        }
    }
    
    
    
    func getOffset(_ ix: Int) -> CGPoint {
        var off: CGPoint
        switch ix {
        case 0:
            off = CGPoint(x: -offset, y: -offset)
        case 1:
            off = CGPoint(x: +offset, y: -offset)
        case 2:
            off = CGPoint(x: -offset, y: +offset)
        case 3:
            off = CGPoint(x: +offset, y: +offset)
        default:
            off = CGPoint(x: 0, y: 0)
        }
        
        return off
    }
    
}
