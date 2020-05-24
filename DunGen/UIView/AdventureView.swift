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
        HStack (spacing: -80){
            MapView()
            DungeonUIView()
                .fixedSize(horizontal: true, vertical: false)
        }
    }
}

struct AdventureView_Previews: PreviewProvider {
    

    static var previews: some View {
        AdventureView()
    }
}
