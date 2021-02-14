//
//  StatusView.swift
//  DunGen
//
//  Created by Richard Moe on 2/13/21.
//  Copyright © 2021 Richard Moe. All rights reserved.
//

import SwiftUI

struct StatusView: View {
    @ObservedObject var adventure: Adventure
    
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(Color.red)
            VStack() {
                Group {
                Text("Status").font(.headline)
                Text("Total Experience: \(100)").font(.body)
                Spacer()
                    Text("Treasure:")
                    TreasureListView(adventure: adventure)
                }
                Spacer()
                HStack {
                    Spacer()
                    Button("ok") {
                        
                    }
                }
            }

        }
        .frame(width: 350, height: 200, alignment: .topLeading)
        .clipped()
        //.clipShape
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatusView(adventure: Global.adventure)
                .previewDevice("iPad Pro (12.9-inch) (4th generation)")
        }
    }
}
