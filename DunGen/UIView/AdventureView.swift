//
//  AdventureView.swift
//  DunGen
//
//  Created by Richard Moe on 5/22/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import SwiftUI

struct AdventureView: View {
    

    
    var body: some View {
        VStack {
            HStack (spacing: -80){
                MapView()
                DungeonUIView(adventure: Global.adventure)
                    .fixedSize(horizontal: true, vertical: false)
            }
            HStack {
                Spacer()
                Button("BATTLE") {
                    if let d = Global.dungeonScene {
                        d.clickButton(name: "BATTLE")
                    }
                }
                Spacer()
                Button("ZOOM") {
                    if let d = Global.dungeonScene {
                        d.clickButton(name: "ZOOM")
                    }
                }
                Spacer()
            }
        }
    }
}

struct AdventureView_Previews: PreviewProvider {
    

    static var previews: some View {
        AdventureView()
    }
}
