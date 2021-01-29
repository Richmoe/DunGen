//
//  AdventureView.swift
//  DunGen
//
//  Created by Richard Moe on 5/22/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import SwiftUI

struct AdventureView: View {
    
        @ObservedObject var adventure: Adventure
        @State var modalDisplayed = false
    @State private var showActionSheet = false
    
    var body: some View {
        VStack {
//            HStack {
//                EmptyView()
//            }
//            .actionSheet(isPresented: $showActionSheet) {
//                ActionSheet(
//                    title: Text("Actions"),
//                    message: Text("Available actions"),
//                    buttons: [
//                        .default(Text("Debug Map")) {
//                            if let d = Global.dungeonScene {
//                                d.clickButton(name: "DEBUGMAP")
//                            }
//                        },
//                        .default(Text("Zoom")) {
//                            if let d = Global.dungeonScene {
//                                d.clickButton(name: "ZOOM")
//                            }
//                        },
//                        .cancel()
//                    ]
//                )
//            }
            HStack (spacing: -80){
                MapView()

                DungeonUIView(adventure: adventure)
                    .frame(maxWidth: 375)
                    //.fixedSize(horizontal: false, vertical: false)
            }
            .overlay(OverlayView(adventure: Global.adventure), alignment: .topLeading)


            HStack {
                Spacer()
                Button("Experience: \(adventure.experienceAccumulator)") {

                }
                Spacer()
                Button("Treasure") {
                    adventure.showTreasure = !adventure.showTreasure
                }
                Spacer()

                
                Button("Debug") {
                    self.showActionSheet = true
                }
                Spacer()

            }
                        .actionSheet(isPresented: $showActionSheet) {
                            ActionSheet(
                                title: Text("Actions"),
                                message: Text("Available actions"),
                                buttons: [
                                    .default(Text("Debug Map")) {
                                        if let d = Global.dungeonScene {
                                            d.clickButton(name: "DEBUGMAP")
                                        }
                                    },
                                    .default(Text("Zoom")) {
                                        if let d = Global.dungeonScene {
                                            d.clickButton(name: "ZOOM")
                                        }
                                    },
                                    .cancel()
                                ]
                            )
                        }
        }


    }
}

struct AdventureView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        AdventureView(adventure: Global.adventure)
    }
}

//extension NSLayoutConstraint {
//
//    override public var description: String {
//        let id = identifier ?? ""
//        return "id: \(id), constant: xx" //you may print whatever you want here
//    }
//}
