//
//  MapView.swift
//  DunGen
//
//  Created by Richard Moe on 5/22/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import SwiftUI
import SpriteKit

struct MapView: UIViewRepresentable {
    
    func makeUIView(context: Context) ->  SKView {
        let view = SKView()
        
        view.allowsTransparency = true
        
        if let scene = DungeonScene(fileNamed: "DungeonScene") {
            scene.backgroundColor = .darkGray

            view.presentScene(scene)
            Global.dungeonScene  = scene
        }
        
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
