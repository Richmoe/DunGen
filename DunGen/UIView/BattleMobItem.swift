//
//  BattleMobItem.swift
//  DunGen
//
//  Created by Richard Moe on 5/16/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import SwiftUI
import SpriteKit

struct BattleMobItem: View {
    @ObservedObject var mob : Mob
    var order: Int
    @ObservedObject var battle: BattleController
    
    
    let colorArray = [Color.blue, Color.red, Color.gray, Color.green, Color.orange, Color.black, Color.pink, Color.purple, Color.yellow]
    
    var body: some View {
        
        HStack {
            Button(action: {
                self.battle.setCurrent(ix: self.order)
                
            })
            {
                ZStack {
                    Image("Sword2")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .opacity(self.battle.currentTargetIx == order ? 1 : 0)
                    Text(self.mob.name.prefix(1))
                        .padding(8)
                        .background(colorArray[ order % colorArray.count ])
                        .foregroundColor(Color.white)
                        .clipShape(Circle())
                }
                
                VStack (alignment: .leading){
                    
                    Text(self.mob.name)
                        .font(.headline)
                    HStack {
                        Text("AC: \(self.mob.armorClass)")
                            .font(.caption)
                        
                    }
                }
            }
            
            Spacer()
            HStack {
                Button(action: {self.mob.decreaseHP()}) {
                    Text("<")
                        .font(.title)
                }
                VStack{
                    Text("HP:")
                        .font(.caption)
                    Text("\(self.mob.hitPoints)")
                        .font(.headline)
                }
                Button(action: {self.mob.increaseHP()}) {
                    Text(">")
                        .font(.title)
                }
            }
            
        }
        .padding(8)
        .border(Color.pink, width: (self.battle.current == order ?  2 : 0))
        .background((self.mob.hitPoints == 0 ? Color.gray : Color.clear))
    }
}

struct BattleMobItem_Previews: PreviewProvider {
    static var previews: some View {
        BattleMobItem(mob: Mob(name: "Goblin", armorClass: 12, hitPoints: 12, initiativeBonus: 2, image: ""), order: Int.random(in: 0...7), battle: BattleController(encounter: Encounter(at: MapPoint(row: 0,col: 0)), map: Map(width: 30, height: 30), tileMap: SKTileMapNode(tileSet: Global.mapTileSet.tileSet, columns: Global.adventure.dungeon.mapWidth, rows: Global.adventure.dungeon.mapHeight, tileSize: CGSize(width: MapTileSet.tileWidth, height: MapTileSet.tileHeight))))
    }
}
