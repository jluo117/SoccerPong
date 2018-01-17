//
//  GameOver.swift
//  Pong
//
//  Created by james luo on 1/9/18.
//  Copyright © 2018 james luo. All rights reserved.
//

import Foundation
import  SpriteKit
class GameOverScene: SKScene{
    var endLabel = SKLabelNode(text: "Game Over")
    var again = SKLabelNode(text: "Tap to Play Again")
    
    override func didMove(to view: SKView){
        endLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 )
        endLabel.fontSize = self.frame.width / 8
        self.addChild(endLabel)
        again.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 4 )
        again.fontSize = self.frame.width / 8
        self.addChild(again)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let moveTo = GameScene(size: self.size)
        moveTo.scaleMode = self.scaleMode
        self.view!.presentScene(moveTo)
    }
}
