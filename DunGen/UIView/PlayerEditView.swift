//
//  PlayerEditView.swift
//  DunGen
//
//  Created by Richard Moe on 2/14/21.
//  Copyright © 2021 Richard Moe. All rights reserved.
//

import SwiftUI

struct PlayerEditView: View {

    
    @State private var name = ""
    @State private var lvl = 1
    @State private var hp = "0"
    @State private var ac = 10
    @State private var initiativeBonus = 0
    
    @ObservedObject var party: Party
    @State private var charNum = 0
    
    var body: some View {
        VStack {
            HStack {
                Button("<") {
                    charNum = -1
                    if (charNum < 0) {
                        charNum = party.player.count - 1
                    }
                }
                Text("Character Details")
                Button(">") {
                    charNum += 1
                    if (charNum >= party.player.count) {
                        charNum = 0
                    }
                }
            }
            HStack {
                Text("Name")
                TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: $party.player[charNum].name)
                //Text("Textfield Name Here")
            }
            HStack {
                Text("Level")
                Stepper(value: $party.player[charNum].level,
                        in: 1...20,
                        step: 1) {
                    Text("\(party.player[charNum].level)")
                }
            }
            HStack {
                Text("HP")
                //Text("Textfield Name Here")
                //Text("Slider or something level Here")
                Stepper(value: $party.player[charNum].hitPoints,
                        in: 1...200,
                        step: 1) {
                    Text("\(party.player[charNum].hitPoints)")
                }
            }
            HStack {
                Text("AC")
                //TextField("Placeholder", text: temp)
                Stepper(value: $party.player[charNum].armorClass,
                        in: 1...25,
                        step: 1) {
                    Text("\(party.player[charNum].armorClass)")
                }
            }
            HStack {
                Text("Initiative Bonus")
                //TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: temp)
                Stepper(value: $party.player[charNum].initiativeBonus,
                        in: -20...20,
                        step: 1) {
                    Text("\(party.player[charNum].initiativeBonus)")
                }
            }
            
        }
    }
}

struct PlayerEditView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerEditView(party: Global.party)
    }
}
