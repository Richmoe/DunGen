//
//  OverlayView.swift
//  DunGen
//
//  Created by Richard Moe on 1/23/21.
//  Copyright © 2021 Richard Moe. All rights reserved.
//

import SwiftUI

struct OverlayView: View {
    
    @ObservedObject var adventure: Adventure
    
    var body: some View {
        
        if (!adventure.inBattle) {
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.white)
                VStack() {
                    Text("Status").font(.headline)
                    Spacer()
                    ScrollView {
                        //ForEach(0 ..< 12) { _ in
                        //    Text("Message").font(.body)
                        //}
                        Text(adventure.currentStatus).font(.body)
                        
                    }
                    HStack() {
                        Button("Search") {
                            if let d = Global.dungeonScene {
                                d.clickButton(name: "Search")
                            }
                        }
                        Spacer()
                        Button("Pick Lock") {
                            if let d = Global.dungeonScene {
                                d.clickButton(name: "Pick")
                            }
                        }
                    }
                }

            }
            .frame(width: 350, height: 200, alignment: .topLeading)
            .clipped()
            //.clipShape(Rectangle().frame(width:350, height:200))
        } else {
            EmptyView()
        }
    }
}

struct OverlayView_Previews: PreviewProvider {
    static var previews: some View {
        OverlayView(adventure: Global.adventure)
    }
}
