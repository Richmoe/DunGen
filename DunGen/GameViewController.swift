//
//  GameViewController.swift
//  DunGen
//
//  Created by Richard Moe on 4/29/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SwiftUI

class GameViewController: UIViewController {

    var currentDungeon: DungeonScene!
    
    @IBOutlet weak var TestButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            // Load the SKScene from 'GameScene.sks'
            if let scene = DungeonScene(fileNamed: "DungeonScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill

                // Present the scene
                view.presentScene(scene)

                currentDungeon = scene

            }
            
            let dungeonUI = DungeonUIView(adventure: currentDungeon.adventure!)
            let uiController = UIHostingController(rootView: dungeonUI)
            addChild(uiController)
            
            uiController.view.frame = view.frame
            uiController.view.backgroundColor = UIColor.clear
            
            view.addSubview(uiController.view)


            view.ignoresSiblingOrder = true

            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    @IBAction func testButtonPressed(_ sender: Any) {
        print ("Here I am!")
        //currentDungeon.testRebuildMap()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
