//
//  DungeonUIView.swift
//  DunGen
//
//  Created by Richard Moe on 5/8/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import SwiftUI


struct DungeonUIView: View {
    
    
    var body: some View {

        ZStack() {
            Image("Char BG")
            .resizable()
                .aspectRatio(contentMode: .fill)
                
            BattleListView(battle: Global.adventure.currentBattle!)
                .padding(.leading, 160)
        }
    }
}

struct DungeonUIView_Previews: PreviewProvider {
    static var previews: some View {
        DungeonUIView()
    }
}
