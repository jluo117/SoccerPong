//
//  menu.swift
//  Pong
//
//  Created by james luo on 1/9/18.
//  Copyright © 2018 james luo. All rights reserved.
//

import UIKit

class menu: UIViewController {

    
   
    @IBOutlet weak var Menu: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       // Menu.frame = CGRect(x: UIScreen.main.bounds.width / 3.5, y: 0, width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Clear(_ sender: UIButton) {
        let highScore = 0
        UserDefaults.standard.set(highScore, forKey: "highScore")
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
