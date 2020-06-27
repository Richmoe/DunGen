//
//  AdventureView.swift
//  DunGen
//
//  Created by Richard Moe on 5/22/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import SwiftUI

struct AdventureView: View {
        @State var modalDisplayed = false
    @State private var showActionSheet = false
    
    var body: some View {
        VStack {
            HStack {
                EmptyView()
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("Actions"),
                    message: Text("Available actions"),
                    buttons: [
                        .default(Text("Battle")),
                        .default(Text("Run away!")),
                    ]
                )
            }
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
                Button("DEBUGMAP") {
                    if let d = Global.dungeonScene {
                        d.clickButton(name: "DEBUGMAP")
                    }
                }
                Spacer()
                
                Button("Show Action") {
                    self.showActionSheet = true
                }
                
                
                //Spacer()
            }

        }


    }
}

struct AdventureView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        AdventureView()
    }
}

extension NSLayoutConstraint {

    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: xx" //you may print whatever you want here
    }
}
