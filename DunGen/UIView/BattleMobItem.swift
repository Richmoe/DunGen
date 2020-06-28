//
//  BattleMobItem.swift
//  DunGen
//
//  Created by Richard Moe on 5/16/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import SwiftUI

struct BattleMobItem: View {
    @ObservedObject var mob : Mob
    var order: Int
    var isCurrent: Bool
    var isTarget: Bool
    
    
    let colorArray = [Color.blue, Color.red, Color.gray, Color.green, Color.orange, Color.black, Color.pink, Color.purple, Color.yellow]
    
    var body: some View {
        
        HStack {
            ZStack {
                Image("Sword2")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .opacity(isTarget ? 1 : 0)
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
        .border(Color.pink, width: (isCurrent == true ?  2 : 0))
        .background((self.mob.hitPoints == 0 ? Color.gray : Color.clear))
    }
}

struct BattleMobItem_Previews: PreviewProvider {
    static var previews: some View {
        BattleMobItem(mob: Mob(name: "Goblin", armorClass: 12, hitPoints: 12, initiativeBonus: 2, image: ""), order: Int.random(in: 0...7), isCurrent: true, isTarget: true)
    }
}
