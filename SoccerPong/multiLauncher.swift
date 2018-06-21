//
//  multiLauncher.swift
//  SoccerPong
//
//  Created by james luo on 6/20/18.
//  Copyright © 2018 james luo. All rights reserved.
//


import UIKit
import SpriteKit
import GameplayKit
var IsmutiPlayer = false
class gameSelector: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = true
    }
    @IBAction func singlePlayer(_ sender: UIButton) {
        self.performSegue(withIdentifier: "launcher", sender: self)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func prefersHomeIndicatorAutoHidden() -> Bool
    {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    @IBAction func multiPlayer(_ sender: UIButton) {
        IsmutiPlayer = true
        self.performSegue(withIdentifier: "launcher", sender: self)
    }
}


