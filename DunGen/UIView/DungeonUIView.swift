//
//  DungeonUIView.swift
//  DunGen
//
//  Created by Richard Moe on 5/8/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import SwiftUI
import SpriteKit

struct DungeonUIView: View {
    
    @ObservedObject var adventure: Adventure
    
    @ViewBuilder
    var body: some View {
        
        if (adventure.inBattle == true) {
            ZStack() {
                Image("Char BG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                
                BattleListView(battle: adventure.currentBattle!)
                    .padding(.leading, 60)
                    .frame(alignment: .top)
                
                
            }
        } else if (adventure.showTreasure) {
            ZStack() {
                Image("Char BG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                
                TreasureListView(adventure: adventure)
                    .padding(.leading, 60)
                    .frame(alignment: .top)
                
                
            }
        } else if (adventure.showCharacters) {
            ZStack() {
                Image("Char BG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                
                PlayerEditView(party: Global.party)
                    .padding(.leading, 60)
                    .frame(alignment: .top)
                
                
            }
        } else {
            EmptyView()
        }
        
    }
}

struct DungeonUIView_Previews: PreviewProvider {
    static var previews: some View {
        DungeonUIView(adventure: Adventure())
    }
}
