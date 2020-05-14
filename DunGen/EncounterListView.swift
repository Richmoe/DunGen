//
//  EncounterListView.swift
//  DunGen
//
//  Created by Richard Moe on 5/9/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import SwiftUI

struct EncounterListView: View {
    
    var mobs : [String] = ["Goblin", "Orc", "Player"]
    var body: some View {
        List {
            ForEach(mobs.indices) { i in
                Text("Mob: \(self.mobs[i])")
            }
                    .listRowBackground(Color.clear)
        }

        
    }
}

struct EncounterListView_Previews: PreviewProvider {
    static var previews: some View {
        EncounterListView(mobs: ["Goblin", "Orc", "Player 1"])
    }
}
