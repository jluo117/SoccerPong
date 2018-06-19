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
    var inPlay = [ball]()
    var player = SKSpriteNode()
    var endLabel = SKLabelNode(text:"Game Over")
    var again = SKLabelNode(text:"Tap to play again")
    var highScoreLabel = SKLabelNode (text:"HighScore")
    var StartLabel = SKLabelNode(text: "Start")
    var onlineScore = SKLabelNode(text: "Global")
    var remainingBalls = 0
    var ballOne: ball?
    var ballTwo: ball?
    var ballThree: ball?
    var powerUp : ball?
    var score = 0
    var userScore: SKLabelNode?
    var playerGoal1: SKSpriteNode?
    var playerGoal2: SKSpriteNode?
    var enemyGoal1: SKSpriteNode?
    var enemyGoal2: SKSpriteNode?
    var enemyGoal1x: Float?
    var enemyGoal2x: Float?
    var enemyGoaly: Float?
    var playerGoal1x: Float?
    var playerGoal2x: Float?
    var playerGoaly: Float?
    var upperBoundy: Float?
    var gameStart = false
    var GameData: SKScene
    init( gameData: SKScene ) {
        gameData.addChild(onlineScore)
        player = gameData.childNode(withName: "player") as! SKSpriteNode
        self.onlineScore.isHidden = true
        gameOver = false
        //self.addChild(player)
        let border = SKPhysicsBody(edgeLoopFrom: gameData.frame)
        border.friction = 0
        border.restitution = 1
        border.applyImpulse(CGVector(dx: 20, dy: -50))
        gameData.physicsBody = border
        let powerUp = gameData.childNode(withName: "PowerUp") as? SKSpriteNode
        powerUp?.size.height = gameData.frame.width/15
        powerUp?.size.width = gameData.frame.width/15
        powerUp?.isPaused = true
        powerUp?.isHidden = true
        powerUp?.removeFromParent()
        let ballOne = gameData.childNode(withName: "BallOne") as? SKSpriteNode
        ballOne?.position = CGPoint(x: 0, y: 0)
        ballOne?.size.height = gameData.frame.width/15
        ballOne?.size.width = gameData.frame.width/15
        ballOne?.isPaused = true
        let ballTwo = gameData.childNode(withName: "BallTwo") as? SKSpriteNode
        ballTwo?.size.height = gameData.frame.width/15
        ballTwo?.size.width = gameData.frame.width/15
        ballTwo?.position = CGPoint(x: gameData.frame.width/4, y: 0)
        ballTwo?.isPaused = true
        let ballThree = gameData.childNode(withName: "Ballthree") as? SKSpriteNode
        ballThree?.size.height = gameData.frame.width/15
        ballThree?.size.width = gameData.frame.width/15
        ballThree?.position = CGPoint(x: -(gameData.frame.width/4), y: 0)
        ballThree?.isPaused = true
        self.userScore = gameData.childNode(withName: "Score") as? SKLabelNode
        self.userScore?.text = "0"
        self.ballOne = ball(nodeID: ballOne!, isPowerUp: false)
        self.ballTwo = ball(nodeID: ballTwo!, isPowerUp: false)
        self.ballThree = ball(nodeID: ballThree!, isPowerUp: false)
        self.powerUp = ball(nodeID: powerUp!, isPowerUp: true)
        self.inPlay = [self.ballOne!,self.ballTwo!,self.ballThree!,self.powerUp!]
        player.position.y = -(gameData.frame.height / 2) + (gameData.frame.height/9) + 5
        player.position.x = 0
        player.size.width = (ballOne?.size.width)! * 2.5
        self.playerGoal1 = (gameData.childNode(withName: "playerGoal1") as? SKSpriteNode)
        self.playerGoal1?.position.x = -(gameData.frame.width / 4)
        self.playerGoal1?.position.y = -(gameData.frame.height / 2)
        self.playerGoal2 = (gameData.childNode(withName: "playerGoal2") as? SKSpriteNode)
        self.playerGoal2?.position.x = gameData.frame.width / 4
        self.playerGoal2?.position.y = -(gameData.frame.height / 2)
        self.playerGoal1?.size.height = gameData.frame.height / 5
        self.playerGoal2?.size.height = gameData.frame.height / 5
        self.enemyGoal1 = (gameData.childNode(withName: "enemyGoal1") as? SKSpriteNode)
        self.enemyGoal1?.position.x = -(gameData.frame.width / 4)
        self.enemyGoal1?.position.y = gameData.frame.height / 2
        self.enemyGoal2 = (gameData.childNode(withName: "enemyGoal2") as? SKSpriteNode)
        self.enemyGoal2?.position.x = gameData.frame.width / 4
        self.enemyGoal2?.position.y = gameData.frame.height / 2
        self.enemyGoal1?.size.height = gameData.frame.height / 5
        self.enemyGoal2?.size.height = gameData.frame.height / 5
        self.enemyGoal1x = Float ((enemyGoal1?.position.x)!)
        self.enemyGoal2x = Float ((enemyGoal2?.position.x)!)
        self.enemyGoaly = Float(player.position.y) * -1.1
        self.playerGoal1x = Float((playerGoal1?.position.x)!)
        self.playerGoal2x = Float((playerGoal2?.position.x)!)
        self.playerGoaly = Float(player.position.y) * 1.1
        self.GameData = gameData
        for i in gameData.children{
            i.isPaused = true
        }
    }
    func updateCall() -> Bool{
        for i in inPlay {
            if (updateScore(ballIn: i)){
                self.userScore?.text = String(score)
                continue
            }
            if (lostBall(ballIn: i)){
                continue
            }
            if (bounce(ballIn: i)){
                continue
            }
        }
        return isOver()
    }
    func bounce(ballIn: ball) -> Bool{
        let ySpeed = -15
        let xCord = Float(ballIn.nodeID.position.x)
        let yCord = Float(ballIn.nodeID.position.y)
        if((xCord < enemyGoal1x!) && (yCord > enemyGoaly! * 1.07 )){
            //i.physicsBody?.velocity.dy = 0
            //  i.position.y = CGFloat(enemyGoaly! * 0.8)
            ballIn.nodeID.physicsBody?.applyImpulse(CGVector(dx: 5, dy: ySpeed))
            return true
        }
        if((xCord > enemyGoal2x!) && (yCord > enemyGoaly! * 1.07 )){
            //i.physicsBody?.velocity.dy = 0
            //i.position.y = CGFloat(enemyGoaly! * 0.8)
            ballIn.nodeID.physicsBody?.applyImpulse(CGVector(dx: -5, dy: ySpeed))
            return true
        }
        if ((xCord < playerGoal1x!) && (yCord < playerGoaly! * 1.07) ){
            //i.physicsBody?.velocity.dy = 0
            //i.position.y = CGFloat(playerGoaly! * 0.8)
            ballIn.nodeID.physicsBody?.applyImpulse(CGVector(dx: 5, dy: -ySpeed))
            return true
        }
        if ((xCord > playerGoal2x!) && (yCord < playerGoaly! * 1.07)){
            //i.physicsBody?.velocity.dy = 0
            //i.position.y = CGFloat(playerGoaly! * 0.8)
            ballIn.nodeID.physicsBody?.applyImpulse(CGVector(dx: -5, dy: -ySpeed ))
            return true
        }
        if abs((Int((ballIn.nodeID.physicsBody?.velocity.dy)!))) < 5{
            ballIn.nodeID.physicsBody?.velocity.dy += -6
            return true
            
        }
        return false
    }
    func lostBall (ballIn: ball) -> Bool{
        let xCord = Float(ballIn.nodeID.position.x)
        let yCord = Float(ballIn.nodeID.position.y)
        if ((xCord > playerGoal1x!) && (xCord < playerGoal2x!) && (yCord < playerGoaly!)){
            ballIn.nodeID.isHidden = true
            ballIn.nodeID.removeFromParent()
            if (!ballIn.isPowerUp){
                remainingBalls -= 1
            }
            return true
        }
        return false
    }
    func updateScore (ballIn: ball) -> Bool{
        
            var ySpeed = -15
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
                    ySpeed += -score
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
                    self.enemyGoal1?.position.x = CGFloat(-(Float(self.GameData.frame.width) / Float (4 + (score / 10))))
                    self.enemyGoal2?.position.x = (CGFloat(Float(self.GameData.frame.width) / Float (4 + (score / 10))))
                    self.enemyGoal1x = Float((self.enemyGoal1?.position.x)!)
                    self.enemyGoal2x = Float((self.enemyGoal2?.position.x)!)
                }
                if (score == 15){
                    self.playerGoal1?.position.x = CGFloat(-(Float(self.GameData.frame.width) / 3))
                    self.playerGoal2?.position.x = CGFloat((Float(self.GameData.frame.width) / 3))
                    self.playerGoal1x = Float((self.playerGoal1?.position.x)!)
                    self.playerGoal2x = Float((self.playerGoal2?.position.x)!)
                    
                }
                if (ballIn.isPowerUp){
                    score += 2
                    ballIn.nodeID.isHidden = true
                    ballIn.nodeID.removeFromParent()
                    if ((score % 10 == 0 || score % 10 == 1) && score < 40){
                        self.enemyGoal1?.position.x = CGFloat(-(Float(self.GameData.frame.width) / Float (4 + (score / 10))))
                        self.enemyGoal2?.position.x = (CGFloat(Float(self.GameData.frame.width) / Float (4 + (score / 10))))
                        self.enemyGoal1x = Float((self.enemyGoal1?.position.x)!)
                        self.enemyGoal2x = Float((self.enemyGoal2?.position.x)!)
                    }
                    if (score % 5 == 0 || score % 5 == 1){
                        for i in self.inPlay{
                            i.nodeID.physicsBody?.applyImpulse((CGVector (dx: 20, dy: -10)))
                        }
                    }
                    if (score == 15 || score == 16){
                        self.playerGoal1?.position.x = CGFloat(-(Float(self.GameData.frame.width) / 3))
                        self.playerGoal2?.position.x = CGFloat((Float(self.GameData.frame.width) / 3))
                        self.playerGoal1x = Float((self.playerGoal1?.position.x)!)
                        self.playerGoal2x = Float((self.playerGoal2?.position.x)!)
                    }
                }
                return true
            }
        return false
        
    }
    func isOver () -> Bool{
        return self.remainingBalls == 0 && (self.powerUp?.nodeID.isHidden)!
    }
    func stableBall(){
        self.ballThree?.nodeID.position = CGPoint(x: -(GameData.frame.width/4), y: 0)
        self.ballTwo?.nodeID.position = CGPoint(x: GameData.frame.width/4, y: 0)
        self.ballOne?.nodeID.position = CGPoint(x: 0, y: 0)
    }
    func startBall (){
        remainingBalls = 3
        if (gameOver){
            self.ballOne?.nodeID.position = CGPoint(x: 0, y: 0)
            self.ballTwo?.nodeID.position = CGPoint(x: GameData.frame.width/4, y: 0)
            self.ballThree?.nodeID.position = CGPoint(x: -(GameData.frame.width/4), y: 0)
            GameData.addChild(ballOne!.nodeID)
            GameData.addChild(ballTwo!.nodeID)
            GameData.addChild(ballThree!.nodeID)
        }
        for i in self.inPlay{
            if (i.isPowerUp) {
                continue
            }
            i.nodeID.isPaused = false
            i.nodeID.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            i.nodeID.physicsBody?.applyImpulse(CGVector(dx: 15, dy: -15))
            i.nodeID.isHidden = false
        }
    }
}
