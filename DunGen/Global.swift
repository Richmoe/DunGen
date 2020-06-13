//
//  Global.swift
//  DunGen
//
//  Created by Richard Moe on 5/22/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation


class Global : ObservableObject {
    static var adventure = Adventure()
    static var mapTileSet = MapTileSet()
    static var isMoving = false //If sprite is moving, don't allow a click override
    static let maxLineOfSight = 6 //Can see 60' or 6 10x10 tiles
    static var dungeonScene : DungeonScene?
}
