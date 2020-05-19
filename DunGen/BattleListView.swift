//
//  BattleListView.swift
//  DunGen
//
//  Created by Richard Moe on 5/9/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import SwiftUI

struct BattleListView: View {
    
    var battle: Battle
    
    var body: some View {
        VStack (spacing: 10) {
            ForEach(0..<battle.initiative.count) { val in
                //Text("\(self.battle.initiative[val].0): \(self.battle.initiative[val].1.name)")
                BattleMobItem(mob: self.battle.initiative[val].1)
                //Spacer()
            }
//            .listRowBackground(Color.clear)
       }
        
        
    }
}

struct BattleListView_Previews: PreviewProvider {
    static var previews: some View {
        BattleListView(battle: Battle(encounter: Encounter(), party: Party()))
    }
}
