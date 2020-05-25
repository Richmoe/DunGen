//
//  BattleListView.swift
//  DunGen
//
//  Created by Richard Moe on 5/9/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import SwiftUI

struct BattleListView: View {
    
    @ObservedObject var battle: BattleController
    
    var body: some View {
        VStack (spacing: 10) {
            Text("Round: \(battle.round)")
            ForEach(0..<battle.initiative.count) { val in
                //Text("\(val): \(self.battle.current), \(Bool(self.battle.current == val))")
                BattleMobItem(mob: self.battle.initiative[val].1, order: val, isCurrent: self.battle.current == val)
                //Spacer()
            }
//            .listRowBackground(Color.clear)
            
            HStack {
                Spacer()
                Button("Next") {
                    self.battle.nextTurn()
                }
                Spacer()
                Button("End Round") {
                    self.battle.nextRound()
                }
                Spacer()
            }
       }
        
        
    }
}

struct BattleListView_Previews: PreviewProvider {
    static var previews: some View {
        BattleListView(battle: BattleController(encounter: Encounter(at: MapPoint(row: 0,col: 0)), party: Party()))
    }
}
