//
//  singlePlayer.swift
//  SoccerPong
//
//  Created by james luo on 6/19/18.
//  Copyright © 2018 james luo. All rights reserved.
//

import Foundation
import SpriteKit
import Firebase
class SinglePlayer :soccerPong{
    override init(gameData: SKScene) {
        super .init(gameData: gameData)
        gameData.addChild(again)
        gameData.addChild(endLabel)
        gameData.addChild(highScoreLabel)
        self.endLabel.isHidden = true
        self.again.isHidden = true
        self.userScore?.position.y = gameData.frame.height / 2.5
        self.userScore?.position.x = -(gameData.frame.width / 2.7)
        StartLabel.position = CGPoint(x: 0, y: gameData.frame.height/8)
        self.StartLabel.fontSize = gameData.frame.width / 8
        gameData.addChild(StartLabel)
        StartLabel.isHidden = false
    }
    func startGame (){
        gameStart = true
        ballOne?.nodeID.isPaused = false
        ballTwo?.nodeID.isPaused = false
        ballThree?.nodeID.isPaused = false
        startBall()
    }
    func update (){
        if (gameOver || (!gameStart)){
            return
        }
        if (updateCall()){
            setUpGameOver()
        }
    }
    func setUpGameOver(){
        self.playerGoal2?.position.x = GameData.frame.width / 4
        self.playerGoal2?.position.y = -(GameData.frame.height / 2)
        self.playerGoal1?.position.x = -(GameData.frame.width / 4)
        self.playerGoal1?.position.y = -(GameData.frame.height / 2)
        self.enemyGoal2?.position.x = (GameData.frame.width / 4)
        self.enemyGoal1?.position.x = -(GameData.frame.width / 4)
        self.enemyGoal1?.position.y = GameData.frame.height / 2
        self.enemyGoal1x = Float ((self.enemyGoal1?.position.x)!)
        self.enemyGoal2x = Float ((self.enemyGoal2?.position.x)!)
        self.enemyGoaly = Float ((self.player.position.y) * -1)
        self.playerGoal1x = Float((self.playerGoal1?.position.x)!)
        self.playerGoal2x = Float((self.playerGoal2?.position.x)!)
        self.playerGoaly = Float((self.player.position.y) - 20)
        self.player.position.x = 0
        for i in GameData.children{
            i.isPaused = true
        }
        var globalScore = 9999
        let ref = Database.database().reference()
        ref.observe(.value) { snapshot in
            let value = snapshot.value as? NSDictionary
            globalScore = Int(value!["Score"] as! Int)
            if (self.score > globalScore){
                ref.setValue(["Score": self.score])
                self.onlineScore.text = "Global HighScore " + String(self.score)
            }
            else{
                self.onlineScore.text = "Global HighScore " + String(globalScore)
            }
            
        }
        var highScore = 0
        
        if let loadScore = UserDefaults.standard.object(forKey: "highScore")as? Int {
            highScore = loadScore
        }
        if (self.score > highScore){
            highScore = self.score
        }
        UserDefaults.standard.set(highScore, forKey: "highScore")
        self.endLabel.position = CGPoint(x: 0, y: 0)
        self.endLabel.fontSize = GameData.frame.width / 8
        //self.addChild(endLabel)
        self.again.position = CGPoint(x: 0, y: GameData.frame.height / 4)
        self.again.fontSize = GameData.frame.width / 8
        //self.addChild(again)
        self.highScoreLabel.text = "HighScore " + String(highScore)
        self.highScoreLabel.position = CGPoint(x: 0, y: -(GameData.frame.height / 8))
        self.highScoreLabel.fontSize = GameData.frame.width / 8
        self.highScoreLabel.isHidden = false
        self.onlineScore.position = CGPoint(x: 0, y: -(GameData.frame.height / 4))
        self.onlineScore.fontSize = GameData.frame.width / 10
        //self.addChild(highScoreLabel!)
        self.endLabel.isHidden = false
        self.again.isHidden = false
        self.onlineScore.text = "Downloading Scores"
        self.onlineScore.isHidden = false
        gameOver = true
    }
    func restartGame()  {
        startBall()
        gameOver = false
    }
    func move(touch: UITouch)  {
        let location = touch.location(in: GameData)
        player.run(SKAction.moveTo(x: location.x, duration: 0.1))
    }
    func touchCheck (touch: UITouch){
        if (!gameStart){
            startGame()
            return
        }
        if (gameOver){
            restartGame()
            return
        }
        move(touch: touch)
    }
}
