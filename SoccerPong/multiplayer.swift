//
//  multiplayer.swift
//  SoccerPong
//
//  Created by james luo on 6/19/18.
//  Copyright © 2018 james luo. All rights reserved.
//

import Foundation
import SpriteKit
class MultiPlayer: soccerPong{
    var player1Score = 0
    var player2Score = 0
    var player2 = SKSpriteNode()
    var player1Ready = SKLabelNode(text: "Player One")
    var player2Ready = SKLabelNode(text: "Player Two")
    var roundOne = SKLabelNode(text: "Round 1")
    var roundTwo = SKLabelNode(text: "Round 2")
    var winningNode = SKLabelNode(text: "Player 1 wins")
    var player1Played = false
    var player2Played = false
    override init(gameData: SKScene) {
        player2 = gameData.childNode(withName: "player2") as! SKSpriteNode
        super.init(gameData: gameData)
        player2.isHidden = false
        player2.position.y = (gameData.frame.height / 2) - (gameData.frame.height/9) - 5
        player2.position.x = 0
        player.color = UIColor(red:1.00, green:0.00, blue:0.00, alpha:1.0)
        player2.color = UIColor(red:0.00, green:1.00, blue:0.00, alpha:1.0)
        gameData.addChild(player1Ready)
        gameData.addChild(player2Ready)
        gameData.addChild(roundOne)
        gameData.addChild(roundTwo)
        self.userScore?.position.y = 0
        self.userScore?.position.x = -(gameData.frame.width / 2.7)
        self.userScore?.zRotation = CGFloat(.pi/2.0)
        roundOne.position = CGPoint(x: 0, y: gameData.frame.height/8)
        self.roundOne.fontSize = gameData.frame.width / 8
        roundOne.isHidden = false
        self.player2Ready.zRotation = CGFloat(Double.pi)
        self.player2Ready.position.x = 0
        self.player2Ready.position.y = gameData.frame.height / 4
        self.player1Ready.position.x = 0
        self.player1Ready.position.y = -gameData.frame.height / 4
        self.player2Ready.isHidden = true
        self.player1Ready.isHidden = false
        GameData.addChild(winningNode)
        winningNode.isHidden = true
    }
    func startGame (){
        winningNode.isHidden = true
        if (!player1Played && !gameStart){
            player1Ready.isHidden = true
            roundOne.isHidden = true
            StartLabel.isHidden = true
            gameStart = true
            player1Played = true
            startBall()
        }
        if (!player2Played && !gameStart){
            player2Ready.isHidden = true
            roundTwo.isHidden = true
            StartLabel.isHidden = true
            gameStart = true
            player2Played = true
            player2Start()
        }
    }
    func update (){
        if !gameStart{
            stableBall()
            return
        }
        if (player1Played && !player2Played){
            for i in inPlay{
                if score(ballIn: i){
                    continue
                }
                if bounce(ballIn: i){
                    continue
                }
                if (lostBall(ballIn: i)){
                    if isOver(){
                        setupNextRound()
                        continue
                    }
                }
            }
            return
        }
        if (player1Played && player2Played){
            for i in inPlay{
                if player2Score(ballIn: i){
                    continue
                }
                if bounce(ballIn: i){
                    continue
                }
                if (lossBall(ballIn: i)){
                    if isOver(){
                        setupNextRound()
                    }
                }
            }
        }
    }
    func setupNextRound (){
        if (player1Played && !player2Played){
            player1Score = self.score
            self.score = 0
            gameOver = true
            gameStart = false
            player2Ready.isHidden = false
            GameData.physicsWorld.gravity.dy = 0.01
        }
        if (player2Played && player1Played){
            player2Score = self.score
            self.score = 0
            gameStart = false
            gameOver = true
            winningNode.position.y = GameData.frame.height / 2
            winningNode.position.x = GameData.frame.width / 2
            if (player1Score > player2Score){
                winningNode.text = "player 1 wins"
            }
            else if (player2Score > player1Score){
                winningNode.text = "player 1 wins"
            }
            else{
                winningNode.text = "Tied"
            }
            winningNode.isHidden = false
        }
    }
    func touch (touch: UITouch){
        if (!gameStart){
            startGame()
        }
        else{
            for i in inPlay{
                if (score(ballIn: i)){
                    continue
                }
            }
        }
    }
    func move (touch: UITouch){
        let location = touch.location(in: GameData)
        if (location.y > 0){
            player2.run(SKAction.moveTo(x: location.x, duration: 0.1))
        }
        else{
            player.run(SKAction.moveTo(x: location.x, duration: 0.1))
        }
    }
    func score (ballIn : ball) -> Bool{
        if (player1Played && !player2Played){
            return updateScore(ballIn: ballIn)
        }
        else{
            return true
        }
    }
    func player2Score (ballIn: ball) -> Bool{
        var ySpeed = 15
        let xCord = Float(ballIn.nodeID.position.x)
        let yCord = Float(ballIn.nodeID.position.y)
        if ((xCord > enemyGoal1x!) && (xCord < enemyGoal2x!) && (yCord > enemyGoaly!)){
            if (ballIn.isPowerUp && self.remainingBalls == 0){
                ballIn.nodeID.isHidden = true
                ballIn.nodeID.removeFromParent()
                self.remainingBalls += 1
                self.GameData.addChild((ballOne?.nodeID)!)
                self.ballOne?.nodeID.isHidden = false
                self.ballOne?.nodeID.position = CGPoint(x: 0, y: 0)
                self.ballOne?.nodeID.physicsBody?.applyImpulse(CGVector(dx: Int(arc4random_uniform(30)) - 15, dy: ySpeed))
                
                return true
                
            }
            score += 1
            
            ballIn.nodeID.position = CGPoint(x: 0, y: 0)
            ballIn.nodeID.physicsBody?.velocity = CGVector(dx: 0, dy: -1)
            if (score < 20){
                ySpeed += score
            }
            else{
                ySpeed = -40
            }
            if score == 4 || score == 14 || score == 24  || score == 30{
                if (self.powerUp?.nodeID.isHidden == false){
                    return true
                }
                self.GameData.addChild((self.powerUp?.nodeID)!)
                self.powerUp?.nodeID.isHidden = false
                self.powerUp?.nodeID.position = CGPoint(x: 0, y: 0)
                self.powerUp?.nodeID.physicsBody?.applyImpulse(CGVector(dx: Int(arc4random_uniform(30)) - 15, dy: ySpeed))
                
            }
            ballIn.nodeID.physicsBody?.velocity = (CGVector(dx: 0, dy: 0))
            ballIn.nodeID.physicsBody?.applyImpulse(CGVector(dx: Int(arc4random_uniform(30)) - 15, dy: ySpeed))
            if (score % 5 == 0){
                for i in self.inPlay{
                    i.nodeID.physicsBody?.applyImpulse((CGVector (dx: 20, dy: -10)))
                }
            }
            if (score % 10 == 0 && score < 40){
                self.playerGoal1?.position.x = CGFloat(-(Float(self.GameData.frame.width) / Float (4 + (score / 10))))
                self.playerGoal2?.position.x = (CGFloat(Float(self.GameData.frame.width) / Float (4 + (score / 10))))
                self.playerGoal1x = Float((self.playerGoal1?.position.x)!)
                self.playerGoal2x = Float((self.playerGoal2?.position.x)!)
            }
            if (score == 15){
                self.enemyGoal1?.position.x = CGFloat(-(Float(self.GameData.frame.width) / 3))
                self.enemyGoal2?.position.x = CGFloat((Float(self.GameData.frame.width) / 3))
                self.enemyGoal1x = Float((self.enemyGoal1?.position.x)!)
                self.enemyGoal2x = Float((self.enemyGoal2?.position.x)!)
                
            }
            if (ballIn.isPowerUp){
                score += 2
                ballIn.nodeID.isHidden = true
                ballIn.nodeID.removeFromParent()
                if ((score % 10 == 0 || score % 10 == 1) && score < 40){
                    self.playerGoal1?.position.x = CGFloat(-(Float(self.GameData.frame.width) / Float (4 + (score / 10))))
                    self.playerGoal2?.position.x = (CGFloat(Float(self.GameData.frame.width) / Float (4 + (score / 10))))
                    self.playerGoal1x = Float((self.playerGoal1?.position.x)!)
                    self.playerGoal2x = Float((self.playerGoal2?.position.x)!)
                }
                if (score % 5 == 0 || score % 5 == 1){
                    for i in self.inPlay{
                        i.nodeID.physicsBody?.applyImpulse((CGVector (dx: 20, dy: 10)))
                    }
                }
                if (score == 15 || score == 16){
                    self.enemyGoal1?.position.x = CGFloat(-(Float(self.GameData.frame.width) / 3))
                    self.enemyGoal2?.position.x = CGFloat((Float(self.GameData.frame.width) / 3))
                    self.enemyGoal1x = Float((self.enemyGoal1?.position.x)!)
                    self.enemyGoal2x = Float((self.enemyGoal2?.position.x)!)
                }
            }
            return true
        }
        return false
        
    }
    func lossBall (ballIn: ball) -> Bool{
        let xCord = Float(ballIn.nodeID.position.x)
        let yCord = Float(ballIn.nodeID.position.y)
        if ((xCord > enemyGoal1x!) && (xCord < enemyGoal2x!) && (yCord < enemyGoaly!)){
            ballIn.nodeID.isHidden = true
            ballIn.nodeID.removeFromParent()
            if (!ballIn.isPowerUp){
                remainingBalls -= 1
            }
            return true
        }
        return false
    }
    func player2Start (){
        remainingBalls = 3
        for i in self.inPlay{
            if (i.isPowerUp) {
                continue
            }
            i.nodeID.isPaused = false
            i.nodeID.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            i.nodeID.physicsBody?.applyImpulse(CGVector(dx: 15, dy: 15))
            i.nodeID.isHidden = false
        }
    }
    

}
