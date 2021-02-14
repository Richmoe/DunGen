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
    
    
    var totalExpThresholdEasy = 0
    let expModMed = 2.0
    let expModHard = 3.0
    let expModDeadly = 4.5
    
    
    let thresholdEasyTable = [0,50,100,150,250,500,600,700,900,1100,1200,1600,2000,2200,2500,2800,3200,4000,4200,4800,5600]
    

    func createParty() {
        
        //temp

            
            var p1 = Player(name: "Cherrydale", level: 4, experience: 0, armorClass: 6, hitPoints: 8, initiativeBonus: 2, avatar: "Avatar1")
            self.addPlayer(p1)
            
            p1 = Player(name: "Tomalot", level: 4, experience: 0, armorClass: 6, hitPoints: 8, initiativeBonus: 2, avatar: "Avatar2")
            self.addPlayer(p1)
            
            p1 = Player(name: "Svenwolf", level: 5, experience: 0, armorClass: 6, hitPoints: 8, initiativeBonus: 2, avatar: "Avatar3")
            self.addPlayer(p1)
            
            p1 = Player(name: "Sookie", level: 5, experience: 0, armorClass: 6, hitPoints: 8, initiativeBonus: 2, avatar: "Avatar4")
            self.addPlayer(p1)
        
            print("Party Average: \(getPartyLevelAverage())")
        
        Global.adventure.challenge = getPartyLevelAverage()

    }
    
    func addPlayer(_ p : Player) {
        player.append(p)
        
        calcPartyDifficulty()
    }
    
    func removePlayer(_ p: Player) {
        //TODO
        
        calcPartyDifficulty()
    }
    
    func getCharXpThreshold(_ p: Player) -> Int {
        
        var l = p.level
        if (l > 20) {
            l = 20
        }
        
        return thresholdEasyTable[l]
    }

    
    func calcPartyDifficulty() {
        
        //This will calc the exp cap for difficulty levels
        //Note that the DND tables are not formulaic but close enough to let the following work: med = 2*ez, hard = 3*ez, deadly = 4.5*ez
        totalExpThresholdEasy = 0
        
        for p in player {
            totalExpThresholdEasy += getCharXpThreshold(p)
        }
        
        print("Party Difficulty: \(totalExpThresholdEasy)")
    
    }
    
    
    func getPartyTargetEncounterExp(type: String) -> Int {
        
        //just using string "Easy, Medium, Hard, Deadly"
        //But only use first char:
        
        let t = type.lowercased().prefix(1)
        switch t {
        case "e":
            return totalExpThresholdEasy
            
        case "m":
            return Int(Double(totalExpThresholdEasy) * expModMed)
        case "h":
            return Int(Double(totalExpThresholdEasy) * expModHard)
        case "d":
            return Int(Double(totalExpThresholdEasy) * expModDeadly)
        default:
            //error out
            return 0
        }
    }
    
    func getPartyLevelAverage() -> Int {
        var sumLevel = 0
        for p in player {
            sumLevel += p.level
        }
        
        //Manual round since I can't be bothered looking up a function, plus I want to round down
        let roundDownAverage = Int(Double(sumLevel) / Double(player.count) - 0.5)
        return (max(1,roundDownAverage))
    }
    
    func initAvatars(onLayer: SKScene) {
        for p in player {
            let a = p.instantiateSprite(at: CGPoint(x: 0, y: 0))

            onLayer.addChild(a)
            avatar.append(a)
        }
    }
    
    func setAt(atPt: CGPoint, atTile: MapPoint) {
        at = atTile
        for i in 0..<player.count {
            let pt = atPt + getOffset(i)
            player[i].at(pt)
        }
        
    }
    
    func moveParty(toPt: CGPoint, toTile: MapPoint) {
        
        at = toTile
        
        for i in 0..<player.count {
            player[i].move(toPt: toPt + getOffset(i))
            
            //let mv = SKAction.move(to: toPt + getOffset(i), duration: 1.0 + (Double.random(in: -0.05...0.05)))
            //avatar[i].run(mv) {
            //    //is moving = false
            //}
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
