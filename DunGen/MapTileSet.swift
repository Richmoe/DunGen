//
//  MapTileSet.swift
//  AdventureDungeon
//
//  Created by Richard Moe on 4/19/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//


import SpriteKit


class MapTileSet {
    
    var tileSet : SKTileSet
    var tileDict = [String: Int]()
    
    static let tileWidth = 128
    static let tileHeight = 128
    
    
    init() {
        print ("Initing MapTileSet")
        let tileTexture = SKTexture(imageNamed: "BaseTile128.png")
        let tileDef = SKTileDefinition(texture: tileTexture)
        let tileGroup = SKTileGroup(tileDefinition: tileDef)
        self.tileSet =  SKTileSet(tileGroups: [tileGroup])
        self.tileDict["PPPP"] = 0
        
        //createAllDirections(imageName: "BaseTile.png", defWallString: "PPPP")
        
        //Top
        createAllDirections(imageName: "WallN128.png", defWallString: "WPPP")
        createAllDirections(imageName: "WallN128.png", defWallString: "SPPP")
 
        createAllDirections(imageName: "DoorN128.png", defWallString: "DPPP")
        
        
        //Corner
        createAllDirections(imageName: "WallNW128.png", defWallString: "WPPW")
        createAllDirections(imageName: "WallNW128.png", defWallString: "SPPW")
        createAllDirections(imageName: "WallNW128.png", defWallString: "WPPS")

        createAllDirections(imageName: "DoorNwW128.png", defWallString: "DPPW")
        createAllDirections(imageName: "DoorNwE128.png", defWallString: "DWPP")
        
        createAllDirections(imageName: "DoorNE128.png", defWallString: "DDPP")
        
        
        //Top & Bottom
        createAllDirections(imageName: "WallNS128.png", defWallString: "WPWP")
        createAllDirections(imageName: "WallNS128.png", defWallString: "SPWP") //This should cover Secret N and Secet S
        
        createAllDirections(imageName: "DoorNwS128.png", defWallString: "DPWP") //This should cover Door N and Door S
        createAllDirections(imageName: "DoorNS128.png", defWallString: "DPDP")
        
        
        //3 wall
        createAllDirections(imageName: "WallNEW128.png", defWallString: "WWPW")
        createAllDirections(imageName: "WallNEW128.png", defWallString: "SWPW")
        createAllDirections(imageName: "WallNEW128.png", defWallString: "WSPW")
        createAllDirections(imageName: "WallNEW128.png", defWallString: "WWPS")
        
        //Door in middle
        createAllDirections(imageName: "DoorNwEW128.png", defWallString: "DWPW")
        
        createAllDirections(imageName: "DoorNwSW128.png", defWallString: "DPWW")
        createAllDirections(imageName: "DoorNwES128.png", defWallString: "DWWP")
        
        //2 door
        createAllDirections(imageName: "DoorNEwS128.png", defWallString: "DDWP")
        
        createAllDirections(imageName: "DoorNEwW128.png", defWallString: "DDPW")
        
        createAllDirections(imageName: "DoorNSwE128.png", defWallString: "DWDP")
        
        
  
        
        //4 wall
        createAllDirections(imageName: "DoorNwESW128.png", defWallString: "DWWW")
         createAllDirections(imageName: "DoorNwESW128.png", defWallString: "DWWS")
            createAllDirections(imageName: "DoorNwESW128.png", defWallString: "DWSW")
            createAllDirections(imageName: "DoorNwESW128.png", defWallString: "DSWW")
        
        //stairs
        createAllDirections(imageName: "StairUpS128.png", defWallString: "+WWW") //Note code doesn't match file name
        createAllDirections(imageName: "StairDS128.png", defWallString: "WW-W")

    }

    func createAllDirections(imageName: String, defWallString: String) {

        var wallString = defWallString
        let tileTexture = SKTexture(imageNamed: imageName)
        var tileDef = SKTileDefinition(texture: tileTexture)

        if (tileDict[wallString] == nil) {
            tileSet.tileGroups.append(SKTileGroup(tileDefinition: tileDef))
            tileDict[wallString] = tileDict.count
        }

        wallString.append(wallString.removeFirst())

        //Rotate for W:
        tileDef = SKTileDefinition(texture: tileTexture)
        tileDef.rotation = .rotation90
        if (tileDict[wallString] == nil) {
            tileSet.tileGroups.append(SKTileGroup(tileDefinition: tileDef))
            tileDict[wallString] = tileDict.count
        }

        wallString.append(wallString.removeFirst())
        
        //Rotate for S:
        tileDef = SKTileDefinition(texture: tileTexture)
        tileDef.rotation = .rotation180
        if (tileDict[wallString] == nil) {
            tileSet.tileGroups.append(SKTileGroup(tileDefinition: tileDef))
            tileDict[wallString] = tileDict.count
        }
        wallString.append(wallString.removeFirst())
        
        //Rotate for E:
        tileDef = SKTileDefinition(texture: tileTexture)
        tileDef.rotation = .rotation270
        if (tileDict[wallString] == nil) {
            tileSet.tileGroups.append(SKTileGroup(tileDefinition: tileDef))
            tileDict[wallString] = tileDict.count
        }

        
    }
    
}
