////
////  GameScene.swift
////  Pong
////
////  Created by james luo on 1/2/18.
////  Copyright © 2018 james luo. All rights reserved.
////
//
//import SpriteKit
//import GameplayKit
//import Firebase
//class multiPlay: SKScene {
//    var gameData : MultiPlayer?
//    //@available(iOS 11.0, *)
//    override func didMove(to view: SKView) {
//        gameData = MultiPlayer(gameData: self)
//    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches{
//            gameData?.touch(touch: touch)
//        }
//        
//        
//    }
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches{
//            gameData?.touch(touch: touch)
//        }
//    }
//    override func update(_ currentTime: TimeInterval) {
//        gameData?.update()
//    }
//}
//
