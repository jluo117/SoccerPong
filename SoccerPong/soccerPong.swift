//
//  soccerPong.swift
//  SoccerPong
//
//  Created by james luo on 6/18/18.
//  Copyright © 2018 james luo. All rights reserved.
//

import Foundation
import Firebase
import SpriteKit
class soccerPong{
    var gameOver = false
    
    var remainingBalls = 0
   
    var score = 0
    var gameStart = false
    var GameData: SKScene
    init( gameData: SKScene ) {
        gameOver = false
        GameData = gameData
    }
    func Addscore (addScore: Int){
        score += addScore
    }
    func startGame()  {
        gameOver = false
        gameStart = true
        remainingBalls = 3
    }
}
