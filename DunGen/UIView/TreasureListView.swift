//
//  TreasureListView.swift
//  DunGen
//
//  Created by Richard Moe on 1/27/21.
//  Copyright © 2021 Richard Moe. All rights reserved.
//

import SwiftUI

struct TreasureListView: View {
    
    @ObservedObject var adventure: Adventure
    
    var body: some View {
        VStack {
            Group {
            Text("Treasure:")
                .font(.headline)
            Text("Platinum: \(adventure.lootAccumulator.platinum)")
                .font(.caption)
            
            Text("Gold: \(adventure.lootAccumulator.gold)")
                .font(.caption)
            Text("Electrum: \(adventure.lootAccumulator.electrum)")
                .font(.caption)
            Text("Silver: \(adventure.lootAccumulator.silver)")
                .font(.caption)
            Text("Copper: \(adventure.lootAccumulator.copper)")
                .font(.caption)
            }
            Text("Gems and Jewelry:")
            ForEach(adventure.lootAccumulator.getGemOrArtReadout(), id: \.self) { item in
                Text(item)
                    .font(.caption)
            }
            Text("Magic:")
            ForEach(adventure.lootAccumulator.getMagicReadout(), id: \.self) { item in
                Text(item)
                    .font(.caption)
            }
        }
    }
}

struct TreasureListView_Previews: PreviewProvider {
    static var previews: some View {
        TreasureListView(adventure: Global.adventure)
    }
}
