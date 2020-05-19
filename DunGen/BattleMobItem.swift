//
//  BattleMobItem.swift
//  DunGen
//
//  Created by Richard Moe on 5/16/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import SwiftUI

struct BattleMobItem: View {
    var mob : Mob
    
    
    var body: some View {
        
        HStack {
            Text(self.mob.name.prefix(1))
                .padding(8)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .clipShape(Circle())
            
            VStack (alignment: .leading){
                
                Text(self.mob.name)
                    .font(.headline)
                HStack {
                    Text("AC: \(self.mob.armorClass)")
                        .font(.caption)
                    
                }
            }
            
            Spacer()
            HStack {
                Button(action: {print ("1")}) {
                    Text("<")
                        .font(.title)
                }
                VStack{
                    Text("HP:")
                        .font(.caption)
                    Text("\(self.mob.hitPoints)")
                        .font(.headline)
                }
                Button(action: {print ("2")}) {
                    Text(">")
                        .font(.title)
                }
            }
        }
    }
}

struct BattleMobItem_Previews: PreviewProvider {
    static var previews: some View {
        BattleMobItem(mob: Mob(name: "Goblin", armorClass: 12, hitPoints: 12, initiativeBonus: 2, image: "") )
    }
}
