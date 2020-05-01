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
    
    
    init() {
        print ("Initing MapTileSet")
        let tileTexture = SKTexture(imageNamed: "BaseTile.png")
        let tileDef = SKTileDefinition(texture: tileTexture)
        let tileGroup = SKTileGroup(tileDefinition: tileDef)
        self.tileSet =  SKTileSet(tileGroups: [tileGroup])
        self.tileDict["PPPP"] = 0
        
        //createAllDirections(imageName: "BaseTile.png", defWallString: "PPPP")
        
        //Top
        createAllDirections(imageName: "WallN.png", defWallString: "WPPP")
        createAllDirections(imageName: "WallN.png", defWallString: "SPPP")
 
        createAllDirections(imageName: "DoorN.png", defWallString: "DPPP")
        
        
        //Corner
        createAllDirections(imageName: "WallNE.png", defWallString: "WWPP")
        createAllDirections(imageName: "WallNE.png", defWallString: "SWPP")
        createAllDirections(imageName: "WallNE.png", defWallString: "WSPP")

        createAllDirections(imageName: "DoorNwE.png", defWallString: "DWPP")
        createAllDirections(imageName: "WallNdE.png", defWallString: "WDPP")
        
        
        //Top & Bottom
        createAllDirections(imageName: "WallNS.png", defWallString: "WPWP")
        createAllDirections(imageName: "WallNS.png", defWallString: "SPWP") //This should cover Secret N and Secet S
        
        createAllDirections(imageName: "DoorNwS.png", defWallString: "DPWP") //This should cover Door N and Door S
        
        
        //3 wall
        createAllDirections(imageName: "WallNES.png", defWallString: "WWWP")
        createAllDirections(imageName: "WallNES.png", defWallString: "SWWP")
        createAllDirections(imageName: "WallNES.png", defWallString: "WSWP")
        createAllDirections(imageName: "WallNES.png", defWallString: "WWSP")
        
        createAllDirections(imageName: "DoorENS.png", defWallString: "WDWP")
        
        createAllDirections(imageName: "WallNEdW.png", defWallString: "WWPD")
        createAllDirections(imageName: "WallNWdE.png", defWallString: "WDPW")
        
        //4 wall
        createAllDirections(imageName: "WallNESdW.png", defWallString: "WDWW")
        
        //stairs
        createAllDirections(imageName: "StairUpS.png", defWallString: "+WWW")
        createAllDirections(imageName: "StairsNdown.png", defWallString: "WW-W")

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
