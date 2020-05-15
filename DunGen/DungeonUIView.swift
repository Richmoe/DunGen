//
//  DungeonUIView.swift
//  DunGen
//
//  Created by Richard Moe on 5/8/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import SwiftUI


struct DungeonUIView: View {
    
    @ObservedObject var party : Party
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Spacer()
                        .frame(width: 3 * geometry.size.width / 4)
                    ZStack() {

                        Image("Char BG")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width / 4)
                                                EncounterListView()
                                                    .frame(height: 650)
                                                    .offset(CGSize(width: 40,height: 0))
                        
                    }
                }
            }
        }
        
    }
}

struct DungeonUIView_Previews: PreviewProvider {
    static var previews: some View {
        DungeonUIView(party: Party())
    }
}
