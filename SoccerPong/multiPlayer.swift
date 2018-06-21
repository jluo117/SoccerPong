//
//  multiPlayer.swift
//  SoccerPong
//
//  Created by james luo on 6/20/18.
//  Copyright © 2018 james luo. All rights reserved.
//
import SpriteKit
import GameplayKit
import Firebase
class multiPlay: SKScene {
    var remainingBalls = 0
    var player = SKSpriteNode()
    var player2 = SKSpriteNode()
    var gameOver = false
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var inPlay = [ball]()
    var endLabel = SKLabelNode(text:"Player 1 win")
    var again = SKLabelNode(text:"Tap to play again")
    var StartLabel = SKLabelNode(text: "Start")
    var onlineScore = SKLabelNode(text: "Global")
    var ballOne: ball?
    var ballTwo: ball?
    var ballThree: ball?
    var powerUp : ball?
    var score = 0
    var player2Score = 0
    var userScore: SKLabelNode?
    var user2Score: SKLabelNode?
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
    var timer = Timer()
    var gameStart = false
    override func didMove(to view: SKView) {
        //self.removeAllChildren()
        self.player2 = self.childNode(withName: "player2") as! SKSpriteNode
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
        let powerUp = self.childNode(withName: "PowerUp") as? SKSpriteNode
        powerUp?.size.height = self.frame.width/15
        powerUp?.size.width = self.frame.width/15
        powerUp?.isPaused = true
        powerUp?.isHidden = true
        powerUp?.removeFromParent()
        let ballOne = self.childNode(withName: "BallOne") as? SKSpriteNode
        ballOne?.position = CGPoint(x: 0, y: 0)
        ballOne?.size.height = self.frame.width/15
        ballOne?.size.width = self.frame.width/15
        ballOne?.isPaused = true
        let ballTwo = self.childNode(withName: "BallTwo") as? SKSpriteNode
        ballTwo?.size.height = self.frame.width/15
        ballTwo?.size.width = self.frame.width/15
        ballTwo?.position = CGPoint(x: self.frame.width/4, y: 0)
        ballTwo?.isPaused = true
        let ballThree = self.childNode(withName: "Ballthree") as? SKSpriteNode
        ballThree?.size.height = self.frame.width/15
        ballThree?.size.width = self.frame.width/15
        ballThree?.position = CGPoint(x: -(self.frame.width/4), y: 0)
        ballThree?.isPaused = true
        self.ballOne = ball(nodeID: ballOne!, isPowerUp: false)
        self.ballTwo = ball(nodeID: ballTwo!, isPowerUp: false)
        self.ballThree = ball(nodeID: ballThree!, isPowerUp: false)
        self.powerUp = ball(nodeID: powerUp!, isPowerUp: true)
        self.inPlay = [self.ballOne!,self.ballTwo!,self.ballThree!,self.powerUp!]
        self.userScore = self.childNode(withName: "Score") as? SKLabelNode
        self.userScore?.text = "0"
        self.user2Score = self.childNode(withName: "Score2") as? SKLabelNode
        self.user2Score?.text = "0"
        self.userScore?.position.y = self.frame.height / 2.5
        self.userScore?.position.x = -(self.frame.width / 2.7)
        player.position.y = -(self.frame.height / 2) + (self.frame.height/9) + 5
        player.position.x = 0
        player.size.width = (ballOne?.size.width)! * 2.5
        player2.position.y = (self.frame.height / 2) + (self.frame.height/9) + 5
        player2.position.x = 0
        player2.size.width = (ballOne?.size.width)! * 2.5
        self.playerGoal1 = (self.childNode(withName: "playerGoal1") as? SKSpriteNode)
        self.playerGoal1?.position.x = -(self.frame.width / 4)
        self.playerGoal1?.position.y = -(self.frame.height / 2)
        self.playerGoal2 = (self.childNode(withName: "playerGoal2") as? SKSpriteNode)
        self.playerGoal2?.position.x = self.frame.width / 4
        self.playerGoal2?.position.y = -(self.frame.height / 2)
        self.playerGoal1?.size.height = self.frame.height / 5
        self.playerGoal2?.size.height = self.frame.height / 5
        self.enemyGoal1 = (self.childNode(withName: "enemyGoal1") as? SKSpriteNode)
        self.enemyGoal1?.position.x = -(self.frame.width / 4)
        self.enemyGoal1?.position.y = self.frame.height / 2
        self.enemyGoal2 = (self.childNode(withName: "enemyGoal2") as? SKSpriteNode)
        self.enemyGoal2?.position.x = self.frame.width / 4
        self.enemyGoal2?.position.y = self.frame.height / 2
        self.enemyGoal1?.size.height = self.frame.height / 5
        self.enemyGoal2?.size.height = self.frame.height / 5
        self.enemyGoal1x = Float ((self.enemyGoal1?.position.x)!)
        self.enemyGoal2x = Float ((self.enemyGoal2?.position.x)!)
        self.enemyGoaly = Float(self.player.position.y) * -1.1
        self.playerGoal1x = Float((self.playerGoal1?.position.x)!)
        self.playerGoal2x = Float((self.playerGoal2?.position.x)!)
        self.playerGoaly = Float(self.player.position.y) * 1.1
        self.addChild(again)
        self.addChild(endLabel)
        self.endLabel.isHidden = true
        self.again.isHidden = true
        for i in self.children{
            i.isPaused = true
        }
        //ballPhys?.removeFromParent()
        // Get label node from scene and store it for use later
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            
            if (self.gameOver){
                self.remainingBalls = 3
                self.ballOne?.nodeID.position = CGPoint(x: 0, y: 0)
                self.ballTwo?.nodeID.position = CGPoint(x: self.frame.width/4, y: 0)
                self.ballThree?.nodeID.position = CGPoint(x: -(self.frame.width/4), y: 0)
                //self.inPlay = [ballOne!,ballTwo!,ballThree!]
                
                for i in self.inPlay{
                    if (i.isPowerUp) {
                        continue
                    }
                    i.nodeID.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    i.nodeID.physicsBody?.applyImpulse(CGVector(dx: 15, dy: -15))
                    i.nodeID.isHidden = false
                }
                for i in self.children{
                    i.isPaused = false
                }
                self.score = 0
                self.player2Score = 0
                self.endLabel.isHidden = true
                self.again.isHidden = true
                self.gameOver = false
                return
            }
            let location = touch.location(in: self)
            if (!self.gameStart){
                self.remainingBalls = 3
                self.gameStart = true
                self.StartLabel.isHidden = true
                for i in self.children{
                    i.isPaused = false
                }
                self.ballOne?.nodeID.physicsBody?.applyImpulse(CGVector(dx: 15, dy: -15))
                self.ballTwo?.nodeID.physicsBody?.applyImpulse(CGVector(dx: 15, dy: -15))
                self.ballThree?.nodeID.physicsBody?.applyImpulse(CGVector(dx: 15, dy: -15))
                return
            }
            if (location.y > 0){
                player2.run(SKAction.moveTo(x: location.x, duration: 0.1))
            }
            else{
            player.run(SKAction.moveTo(x: location.x, duration: 0.1))
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if (location.y > 0){
                player2.run(SKAction.moveTo(x: location.x, duration: 0.1))
            }
            else{
                player.run(SKAction.moveTo(x: location.x, duration: 0.1))
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        if (!self.gameStart){
            self.ballThree?.nodeID.position = CGPoint(x: -(self.frame.width/4), y: 0)
            self.ballTwo?.nodeID.position = CGPoint(x: self.frame.width/4, y: 0)
            self.ballOne?.nodeID.position = CGPoint(x: 0, y: 0)
            return
        }
        if (self.gameOver){
            
            return
        }
        
        for i in inPlay{
            if (i.nodeID.isHidden){
                continue
            }
            let ySpeed = -15
            let xCord = Float(i.nodeID.position.x)
            let yCord = Float(i.nodeID.position.y)
            if ((xCord > enemyGoal1x!) && (xCord < enemyGoal2x!) && (yCord > enemyGoaly!)){
                score += 1
                i.nodeID.position = CGPoint(x: 0, y: 0)
                i.nodeID.physicsBody?.velocity = CGVector(dx: 0, dy: -1)
                i.nodeID.physicsBody?.velocity = (CGVector(dx: 0, dy: 0))
                i.nodeID.physicsBody?.applyImpulse(CGVector(dx: Int(arc4random_uniform(30)) - 15, dy: ySpeed))
            }
            else if ((xCord > playerGoal1x!) && (xCord < playerGoal2x!) && (yCord < playerGoaly!)){
                player2Score += 1
                i.nodeID.position = CGPoint(x: 0, y: 0)
                i.nodeID.physicsBody?.velocity = CGVector(dx: 0, dy: 1)
                i.nodeID.physicsBody?.velocity = (CGVector(dx: 0, dy: 0))
                i.nodeID.physicsBody?.applyImpulse(CGVector(dx: Int(arc4random_uniform(30)) - 15, dy: -ySpeed))
                
            }
            else if((xCord < enemyGoal1x!) && (yCord > enemyGoaly! * 1.07 )){
                //i.physicsBody?.velocity.dy = 0
                //  i.position.y = CGFloat(enemyGoaly! * 0.8)
                i.nodeID.physicsBody?.applyImpulse(CGVector(dx: 5, dy: ySpeed))
            }
            else if((xCord > enemyGoal2x!) && (yCord > enemyGoaly! * 1.07 )){
                //i.physicsBody?.velocity.dy = 0
                //i.position.y = CGFloat(enemyGoaly! * 0.8)
                i.nodeID.physicsBody?.applyImpulse(CGVector(dx: -5, dy: ySpeed))
            }
            else if ((xCord < playerGoal1x!) && (yCord < playerGoaly! * 1.07) ){
                //i.physicsBody?.velocity.dy = 0
                //i.position.y = CGFloat(playerGoaly! * 0.8)
                i.nodeID.physicsBody?.applyImpulse(CGVector(dx: 5, dy: -ySpeed))
            }
            else if ((xCord > playerGoal2x!) && (yCord < playerGoaly! * 1.07)){
                //i.physicsBody?.velocity.dy = 0
                //i.position.y = CGFloat(playerGoaly! * 0.8)
                i.nodeID.physicsBody?.applyImpulse(CGVector(dx: -5, dy: -ySpeed ))
            }
            else if abs((Int((i.nodeID.physicsBody?.velocity.dy)!))) < 5{
                i.nodeID.physicsBody?.velocity.dy += -6
                
            }
        }
        self.userScore?.text = String(score)
        self.user2Score?.text = String(player2Score)
        if (score >= 15){
            gameOver = true
            endLabel.text = "Player 1 Wins"
            endLabel.isHidden = false
            endLabel.position = CGPoint(x: 0, y: self.frame.height / 2)
            again.isHidden = false
            again.position = CGPoint(x: 0, y: self.frame.height / 4)
            for i in inPlay{
                i.nodeID.isHidden = true
            }
        }
        // Called before each frame is rendered
    }
    
}

