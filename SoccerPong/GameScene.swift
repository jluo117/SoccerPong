//
//  GameScene.swift
//  Pong
//
//  Created by james luo on 1/2/18.
//  Copyright © 2018 james luo. All rights reserved.
//

import SpriteKit
import GameplayKit
import Firebase
class GameScene: SKScene {
    var player = SKSpriteNode()
    var gameOver = false
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var inPlay = [SKNode]()
    var endLabel = SKLabelNode(text:"Game Over")
    var again = SKLabelNode(text:"Tap to play again")
    var highScoreLabel = SKLabelNode (text:"HighScore")
    var StartLabel = SKLabelNode(text: "Start")
    var onlineScore = SKLabelNode(text: "Global")
    var ballOne: SKSpriteNode?
    var ballTwo: SKSpriteNode?
    var ballThree: SKSpriteNode?
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
    var timer = Timer()
    var gameStart = false
    override func didMove(to view: SKView) {
        //self.removeAllChildren()
        StartLabel.position = CGPoint(x: 0, y: self.frame.height/8)
        self.StartLabel.fontSize = self.frame.width / 8
        self.addChild(StartLabel)
        StartLabel.isHidden = false
        self.addChild(onlineScore)
        self.onlineScore.isHidden = true
        gameOver = false
        player = self.childNode(withName: "player") as! SKSpriteNode
        //self.addChild(player)
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        border.applyImpulse(CGVector(dx: 20, dy: -50))
        self.physicsBody = border
        self.ballOne = self.childNode(withName: "BallOne") as? SKSpriteNode
        self.ballOne?.position = CGPoint(x: 0, y: 0)
        self.ballOne?.size.height = self.frame.width/15
        self.ballOne?.size.width = self.frame.width/15
        
        self.ballTwo = self.childNode(withName: "BallTwo") as? SKSpriteNode
        self.ballTwo?.size.height = self.frame.width/15
        self.ballTwo?.size.width = self.frame.width/15
        self.ballTwo?.position = CGPoint(x: self.frame.width/4, y: 0)
        self.ballThree = self.childNode(withName: "Ballthree") as? SKSpriteNode
        self.ballThree?.size.height = self.frame.width/15
        self.ballThree?.size.width = self.frame.width/15
        self.ballThree?.position = CGPoint(x: -(self.frame.width/4), y: 0)
        self.inPlay = [ballOne!,ballTwo!,ballThree!]
        
        self.userScore = self.childNode(withName: "Score") as? SKLabelNode
        self.userScore?.text = "0"
        self.userScore?.position.y = self.frame.height / 2.5
        self.userScore?.position.x = -(self.frame.width / 2.7)
        player.position.y = -(self.frame.height / 2) + (self.frame.height/9) + 5
        player.position.x = 0
        player.size.width = self.frame.width / 5
        self.playerGoal1 = (self.childNode(withName: "playerGoal1") as? SKSpriteNode)
        self.playerGoal1?.position.x = -(self.frame.width / 4)
        self.playerGoal1?.position.y = -(self.frame.height / 2)
        self.playerGoal2 = (self.childNode(withName: "playerGoal2") as? SKSpriteNode)
        self.playerGoal2?.position.x = self.frame.width / 4
        self.playerGoal2?.position.y = -(self.frame.height / 2)
        self.enemyGoal1 = (self.childNode(withName: "enemyGoal1") as? SKSpriteNode)
        self.enemyGoal1?.position.x = -(self.frame.width / 4)
        self.enemyGoal1?.position.y = self.frame.height / 2
        self.enemyGoal2 = (self.childNode(withName: "enemyGoal2") as? SKSpriteNode)
        self.enemyGoal2?.position.x = self.frame.width / 4
        self.enemyGoal2?.position.y = self.frame.height / 2
        self.enemyGoal1x = Float ((self.enemyGoal1?.position.x)!)
        self.enemyGoal2x = Float ((self.enemyGoal2?.position.x)!)
        self.enemyGoaly = Float ((self.player.position.y) * -1)
        self.playerGoal1x = Float((self.playerGoal1?.position.x)!)
        self.playerGoal2x = Float((self.playerGoal2?.position.x)!)
        self.playerGoaly = Float((self.player.position.y) - 20)
        self.addChild(again)
        self.addChild(endLabel)
        self.addChild(highScoreLabel)
        self.endLabel.isHidden = true
        self.again.isHidden = true
        self.highScoreLabel.isHidden = true
        for i in self.children{
            i.isPaused = true
        }
        //ballPhys?.removeFromParent()
        // Get label node from scene and store it for use later
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            if (self.gameOver){
                self.ballOne?.position = CGPoint(x: 0, y: 0)
                self.ballTwo?.position = CGPoint(x: self.frame.width/4, y: 0)
                self.ballThree?.position = CGPoint(x: -(self.frame.width/4), y: 0)

                //self.inPlay = [ballOne!,ballTwo!,ballThree!]
                
                for i in self.inPlay{
                    i.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    i.physicsBody?.applyImpulse(CGVector(dx: 20, dy: -20))
                    i.isHidden = false
                }
                for i in self.children{
                    i.isPaused = false
                }
                self.score = 0
                self.endLabel.isHidden = true
                self.again.isHidden = true
                self.highScoreLabel.isHidden = true
                self.gameOver = false
                self.onlineScore.isHidden = true
                return
            }
            let location = touch.location(in: self)
            if (!self.gameStart){
                self.gameStart = true
                self.StartLabel.isHidden = true
                for i in self.children{
                    i.isPaused = false
                }
                self.ballOne?.physicsBody?.applyImpulse(CGVector(dx: 20, dy: -20))
                self.ballTwo?.physicsBody?.applyImpulse(CGVector(dx: 20, dy: -20))
                self.ballThree?.physicsBody?.applyImpulse(CGVector(dx: 20, dy: -20))
                return
            }
            player.run(SKAction.moveTo(x: location.x, duration: 0.1))
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            player.run(SKAction.moveTo(x: location.x, duration: 0.1))
        }   
    }
    override func update(_ currentTime: TimeInterval) {
        if (!self.gameStart){
            return
        }
        if (self.gameOver){
            
            return
        }

        for i in inPlay{
            if (i.isHidden){
                continue
            }
            var ySpeed = -20
            let xCord = Float(i.position.x)
            let yCord = Float(i.position.y)
            if ((xCord > enemyGoal1x!) && (xCord < enemyGoal2x!) && (yCord > enemyGoaly!)){
                score += 1
                i.position = CGPoint(x: 0, y: 0)
                i.physicsBody?.velocity = CGVector(dx: 0, dy: -1)
                if (score < 30){
                    ySpeed += -score
                }
                else{
                    ySpeed = -50
                }
                i.physicsBody?.velocity = (CGVector(dx: 0, dy: 0))
                i.physicsBody?.applyImpulse(CGVector(dx: Int(arc4random_uniform(30)) - 15, dy: ySpeed))
                if (score % 5 == 0){
                    for i in self.inPlay{
                        i.physicsBody?.applyImpulse((CGVector (dx: 20, dy: -10)))
                    }
                }
                if (score % 10 == 0 && score < 40){
                    self.enemyGoal1?.position.x = CGFloat(-(Float(self.frame.width) / Float (4 + (score / 10))))
                    self.enemyGoal2?.position.x = (CGFloat(Float(self.frame.width) / Float (4 + (score / 10))))
                    self.enemyGoal1x = Float((self.enemyGoal1?.position.x)!)
                    self.enemyGoal2x = Float((self.enemyGoal2?.position.x)!)
                }
                if (score == 15){
                    self.playerGoal1?.position.x = CGFloat(-(Float(self.frame.width) / 3))
                    self.playerGoal2?.position.x = CGFloat((Float(self.frame.width) / 3))
                    self.playerGoal1x = Float((self.playerGoal1?.position.x)!)
                    self.playerGoal2x = Float((self.playerGoal2?.position.x)!)
                }
            }
            else if ((xCord > playerGoal1x!) && (xCord < playerGoal2x!) && (yCord < playerGoaly!)){
                i.isHidden = true
                for j in self.inPlay{
                    if j.isHidden == false{
                        self.bounce()
                        return
                    }
                }
                self.gameOver = true
                self.playerGoal2?.position.x = self.frame.width / 4
                self.playerGoal2?.position.y = -(self.frame.height / 2)
                self.playerGoal1?.position.x = -(self.frame.width / 4)
                self.playerGoal1?.position.y = -(self.frame.height / 2)
                self.enemyGoal2?.position.x = (self.frame.width / 4)
                self.enemyGoal1?.position.x = -(self.frame.width / 4)
                self.enemyGoal1?.position.y = self.frame.height / 2
                self.enemyGoal1x = Float ((self.enemyGoal1?.position.x)!)
                self.enemyGoal2x = Float ((self.enemyGoal2?.position.x)!)
                self.enemyGoaly = Float ((self.player.position.y) * -1)
                self.playerGoal1x = Float((self.playerGoal1?.position.x)!)
                self.playerGoal2x = Float((self.playerGoal2?.position.x)!)
                self.playerGoaly = Float((self.player.position.y) - 20)
                self.player.position.x = 0
                for i in self.children{
                    i.isPaused = true
                }
                var globalScore = 9999
                var ref = Database.database().reference()
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
                    self.onlineScore.isHidden = false
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
                self.endLabel.fontSize = self.frame.width / 8
                //self.addChild(endLabel)
                self.again.position = CGPoint(x: 0, y: self.frame.height / 4)
                self.again.fontSize = self.frame.width / 8
                //self.addChild(again)
                self.highScoreLabel.text = "HighScore " + String(highScore)
                self.highScoreLabel.position = CGPoint(x: 0, y: -(self.frame.height / 8))
                self.highScoreLabel.fontSize = self.frame.width / 8
                self.highScoreLabel.isHidden = false
                self.onlineScore.position = CGPoint(x: 0, y: -(self.frame.height / 4))
                self.onlineScore.fontSize = self.frame.width / 10
                //self.addChild(highScoreLabel!)
                self.endLabel.isHidden = false
                self.again.isHidden = false
            }
            else if((xCord < enemyGoal1x!) && (yCord > enemyGoaly!)){
                //i.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                i.physicsBody?.applyImpulse(CGVector(dx: 5, dy: -(ySpeed/2)))
            }
            else if((xCord > enemyGoal2x!) && (yCord > enemyGoaly!)){
                //i.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                i.physicsBody?.applyImpulse(CGVector(dx: -5, dy: -(ySpeed/2)))
            }
            else if ((xCord < playerGoal1x!) && (yCord < playerGoaly!) ){
                //i.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                i.physicsBody?.applyImpulse(CGVector(dx: 5, dy:(ySpeed/2)))
            }
            else if ((xCord > playerGoal2x!) && (yCord < playerGoaly!)){
                //i.physicsBody?.velocity = CGVector(dx: -5, dy: 10)
                i.physicsBody?.applyImpulse(CGVector(dx: -5, dy: ySpeed/2))
            }
        }
        self.userScore?.text = String(score)
                // Called before each frame is rendered
    }
    func bounce(){
        for i in self.inPlay{
            i.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -0.05))
        }
    }
}
