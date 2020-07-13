//
//  Global.swift
//  DunGen
//
//  Created by Richard Moe on 5/22/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation
import SpriteKit


class Global : ObservableObject {
    static var adventure = Adventure()
    static var mapTileSet = MapTileSet()
    static var isMoving = false //If sprite is moving, don't allow a click override
    static let maxLineOfSight = 6 //Can see 60' or 6 10x10 tiles
    static var dungeonScene : DungeonScene?
    
    static let zPosMob = CGFloat(30.0)
    static let zPosDrop = CGFloat(25.0)
    static let zPosTarget = CGFloat(20.0)
    static let zPosSelection = CGFloat(10.0)
    
    //Picking light/dark alternating so we can assum rendering white text over evens
    //from here: https://neverwintervault.org/sites/neverwintervault.org/files/project/1814/images/p1jhlng.jpg
    static let selectionColor: [UIColor] = [
        UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.75), //Red
        UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.75), //Blue
        
        UIColor(red: 1.0, green: 0.95, blue: 0.0, alpha: 0.75), //gold
        UIColor(red: 0.0, green: 0.4, blue: 0.0, alpha: 0.75), //darkgreen
        
        UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.75), //cyan
        UIColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 0.75), //purple
        
        UIColor(red: 1.0, green: 0.4, blue: 0.7, alpha: 0.75), //hotpink
        UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.75), //gray
        
        UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 0.75), //limegreen
        UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 0.75), //darkred
        
        UIColor(red: 0.94, green: 0.9, blue: 0.55, alpha: 0.75), //Khaki
        UIColor(red: 0.0, green: 0.0, blue: 0.4, alpha: 0.75), //indigo
        
        UIColor(red: 1.0, green: 0.5, blue: 0.3, alpha: 0.75), //coral
        UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.75), //black
        
        UIColor(red: 0.53, green: 0.8, blue: 0.97, alpha: 0.75), //lightskyblue
        UIColor(red: 0.51, green: 0.35, blue: 0.07, alpha: 0.75), //saddlebrown
//        UIColor.red,
//        UIColor.blue,
//        UIColor.green,
//        UIColor.magenta,
//        UIColor.cyan,
//        UIColor.yellow,
//        UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.75), //Red
//        UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.75), //Blue
//
//        UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.75), //gold
//
//        UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 0.75), //darkgreen
//        UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.75),
//        UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.75),
//
//        UIColor(red: 1.0, green: 0.0, blue: 0.5, alpha: 0.75),
//        UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.75),
//        UIColor(red: 0.5, green: 0.0, blue: 1.0, alpha: 0.75),
//
//        UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.75),
//        UIColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 0.75),
//        UIColor(red: 0.5, green: 1.0, blue: 0.0, alpha: 0.75),

    ]
}
