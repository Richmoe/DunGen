//
//  BattleListView.swift
//  DunGen
//
//  Created by Richard Moe on 5/9/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import SwiftUI
import SpriteKit

struct BattleListView: View {
    
    @ObservedObject var battle: BattleController
    
    var body: some View {
        VStack (spacing: 5) {
            Text("Round: \(battle.round)")
            ForEach(0..<battle.initiativeMobs.count) { ix in
                BattleMobItem(mob: self.battle.initiativeMobs[ix], order: ix, battle: self.battle)
                //Spacer()
            }
//            .listRowBackground(Color.clear)
//            //List is a problem so we won't use it:
//            List(battle.initiativeMobs.indices, id: \.self) { ix in
//                BattleMobItem(mob: self.battle.initiativeMobs[ix], order: ix, isCurrent: self.battle.current == ix, isTarget: self.battle.currentTargetIx == ix)
//
//            }
            
            VStack {
                //Spacer()
                Button("Next") {
                    self.battle.nextTurn()
                }
                .padding(10)
                //Spacer()
                Button("End Round") {
                    self.battle.nextRound()
                }
                .padding(10)
                //Spacer()
                Button("Cancel Encounter") {
                    self.battle.cancelEncounter()
                }
                .padding(10)
                //Spacer()
            }
        }
                    //.background(Color.red)



    
        
        
    }
}

struct BattleListView_Previews: PreviewProvider {
    
    static var previews: some View {
        BattleListView(battle: BattleController(encounter: Encounter(at: MapPoint(row: 0,col: 0)), map: Map(width: 30, height: 30), tileMap: SKTileMapNode(tileSet: Global.mapTileSet.tileSet, columns: Global.adventure.dungeon.mapWidth, rows: Global.adventure.dungeon.mapHeight, tileSize: CGSize(width: MapTileSet.tileWidth, height: MapTileSet.tileHeight))))
    }
}
