//
//  playerSelection.swift
//  SoccerPong
//
//  Created by james luo on 4/26/18.
//  Copyright © 2018 james luo. All rights reserved.
//

import UIKit
var multiPlayer = false
class playerSelection: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func singlePlayer(_ sender: UIButton) {
        multiPlayer = false
        self.performSegue(withIdentifier: "startGame", sender: self)
    }
    
    @IBAction func multiplayer(_ sender: UIButton) {
        multiPlayer = true
        self.performSegue(withIdentifier: "startGame", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
