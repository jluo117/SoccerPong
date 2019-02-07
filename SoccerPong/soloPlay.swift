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
import AVFoundation
class soloPlay: SKScene {
    var remainingBalls = 0
    var player = SKSpriteNode()
    var player2 = SKSpriteNode()
    var user2Score : SKLabelNode?
    var gameOver = false
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var inPlay = [ball]()
    var endLabel = SKLabelNode(text:"Game Over")
    var again = SKLabelNode(text:"Tap to play again")
    var highScoreLabel = SKLabelNode (text:"HighScore")
    var StartLabel = SKLabelNode(text: "Start")
    var onlineScore = SKLabelNode(text: "Global")
    var ballOne: ball?
    var ballTwo: ball?
    var ballThree: ball?
    var powerUp : ball?
    var score = 0
    var score2 = 0
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
    var timer = Timer()
    var gameStart = false
    override func didMove(to view: SKView) {
        let sound:SKAction = SKAction.playSoundFileNamed("gamemusic.mp3", waitForCompletion: true)
        let loopSound:SKAction = SKAction.repeatForever(sound)
        self.run(loopSound)
        if (!IsmutiPlayer){
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
        self.userScore = self.childNode(withName: "Score2") as? SKLabelNode
        self.userScore?.text = "0"
        self.user2Score = self.childNode(withName: "Score") as? SKLabelNode
        user2Score?.isHidden = true
        player2.isHidden = true
        self.userScore?.position.y = self.frame.height / 2.5
        self.userScore?.position.x = -(self.frame.width / 2.7)
        player.position.y = -(self.frame.height / 2) + (self.frame.height/9) + 5
        player.position.x = 0
        player.size.width = (ballOne?.size.width)! * 2.5
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
        self.addChild(highScoreLabel)
        self.endLabel.isHidden = true
        self.again.isHidden = true
        self.highScoreLabel.isHidden = true
        for i in self.children{
            i.isPaused = true
        }
            self.player2 = self.childNode(withName: "player2") as! SKSpriteNode
            self.player2.isHidden = true
        }
        else{
            self.player2 = self.childNode(withName: "player2") as! SKSpriteNode
            self.player2.isHidden = false
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
            self.user2Score?.position.y = self.frame.height / 2.5
            self.user2Score?.position.x = -(self.frame.width / 2.7)
            self.user2Score?.zRotation = CGFloat(.pi/1.0)
            self.userScore?.position.y = -self.frame.height / 2.5
            self.userScore?.position.x = -(self.frame.width / 2.7)
            player.position.y = -(self.frame.height / 2) + (self.frame.height/9) + 5
            player.position.x = 0
            player.size.width = (ballOne?.size.width)! * 2.5
            player2.position.y = (self.frame.height / 2) - (self.frame.height/9) - 5
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
        //ballPhys?.removeFromParent()
        // Get label node from scene and store it for use later
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (IsmutiPlayer){
            multiTouchStart(touches: touches)
            return
        }
        for touch in touches{
            
            if (self.gameOver){
                self.remainingBalls = 3
                self.onlineScore.isHidden = true
                self.ballOne?.nodeID.position = CGPoint(x: 0, y: 0)
                self.ballTwo?.nodeID.position = CGPoint(x: self.frame.width/4, y: 0)
                self.ballThree?.nodeID.position = CGPoint(x: -(self.frame.width/4), y: 0)
                self.addChild(ballOne!.nodeID)
                self.addChild(ballTwo!.nodeID)
                self.addChild(ballThree!.nodeID)
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
                self.endLabel.isHidden = true
                self.again.isHidden = true
                self.gameOver = false
                self.highScoreLabel.isHidden = true
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
            player.run(SKAction.moveTo(x: location.x, duration: 0.1))
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (IsmutiPlayer){
            touchMoveMulti(touches: touches)
            return
        }
        for touch in touches{
            let location = touch.location(in: self)
            player.run(SKAction.moveTo(x: location.x, duration: 0.1))
        }   
    }
    override func update(_ currentTime: TimeInterval) {
        if (IsmutiPlayer){
            multiUpdate()
            return
        }
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
            var ySpeed = -15
            let xCord = Float(i.nodeID.position.x)
            let yCord = Float(i.nodeID.position.y)
            if ((xCord > enemyGoal1x!) && (xCord < enemyGoal2x!) && (yCord > enemyGoaly!)){
                if (i.isPowerUp && self.remainingBalls == 0){
                    i.nodeID.isHidden = true
                    i.nodeID.removeFromParent()
                    self.remainingBalls += 1
                    self.addChild((ballOne?.nodeID)!)
                    self.ballOne?.nodeID.isHidden = false
                    self.ballOne?.nodeID.position = CGPoint(x: 0, y: 0)
                    self.ballOne?.nodeID.physicsBody?.applyImpulse(CGVector(dx: Int(arc4random_uniform(30)) - 15, dy: ySpeed))
                    
                    return
                    
                }
                    score += 1
               
                i.nodeID.position = CGPoint(x: 0, y: 0)
                i.nodeID.physicsBody?.velocity = CGVector(dx: 0, dy: -1)
                if (score < 20){
                    ySpeed += -score
                }
                else{
                    ySpeed = -40
                }
                if score == 4 || score == 14 || score == 24  || score == 30{
                    if (self.powerUp?.nodeID.isHidden == false){
                        continue
                    }
                    self.addChild((self.powerUp?.nodeID)!)
                    self.powerUp?.nodeID.isHidden = false
                    self.powerUp?.nodeID.position = CGPoint(x: 0, y: 0)
                    self.powerUp?.nodeID.physicsBody?.applyImpulse(CGVector(dx: Int(arc4random_uniform(30)) - 15, dy: ySpeed))
                    
                }
                i.nodeID.physicsBody?.velocity = (CGVector(dx: 0, dy: 0))
                i.nodeID.physicsBody?.applyImpulse(CGVector(dx: Int(arc4random_uniform(30)) - 15, dy: ySpeed))
                if (score % 5 == 0){
                    for i in self.inPlay{
                        i.nodeID.physicsBody?.applyImpulse((CGVector (dx: 20, dy: -10)))
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
                if (i.isPowerUp){
                    score += 2
                    i.nodeID.isHidden = true
                    i.nodeID.removeFromParent()
                    if ((score % 10 == 0 || score % 10 == 1) && score < 40){
                        self.enemyGoal1?.position.x = CGFloat(-(Float(self.frame.width) / Float (4 + (score / 10))))
                        self.enemyGoal2?.position.x = (CGFloat(Float(self.frame.width) / Float (4 + (score / 10))))
                        self.enemyGoal1x = Float((self.enemyGoal1?.position.x)!)
                        self.enemyGoal2x = Float((self.enemyGoal2?.position.x)!)
                    }
                    if (score % 5 == 0 || score % 5 == 1){
                        for i in self.inPlay{
                            i.nodeID.physicsBody?.applyImpulse((CGVector (dx: 20, dy: -10)))
                        }
                }
                    if (score == 15 || score == 16){
                        self.playerGoal1?.position.x = CGFloat(-(Float(self.frame.width) / 3))
                        self.playerGoal2?.position.x = CGFloat((Float(self.frame.width) / 3))
                        self.playerGoal1x = Float((self.playerGoal1?.position.x)!)
                        self.playerGoal2x = Float((self.playerGoal2?.position.x)!)
                    }
                }
            }
            else if ((xCord > playerGoal1x!) && (xCord < playerGoal2x!) && (yCord < playerGoaly!)){
                i.nodeID.isHidden = true
                i.nodeID.removeFromParent()
                if (!i.isPowerUp){
                     i.nodeID.removeFromParent()
                     self.remainingBalls += -1
                }
                if self.remainingBalls == 0 && (self.powerUp?.nodeID.isHidden)!{
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
                let ref = Database.database().reference()
                    let functions = Functions.functions()
                    functions.httpsCallable("helloWorld")   
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
                self.onlineScore.text = "Downloading Scores"
                self.onlineScore.isHidden = false
                self.gameOver = true
            }
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
                // Called before each frame is rendered
    }
    func multiUpdate (){
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
                score2 += 1
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
        self.user2Score?.text = String(score2)
        if (score >= 15){
            gameOver = true
            endLabel.text = "Player 1 Wins"
            endLabel.isHidden = false
            endLabel.position = CGPoint(x: 0, y: self.frame.height / 8)
            again.isHidden = false
            again.position = CGPoint(x: 0, y: -self.frame.height / 8)
            for i in inPlay{
                i.nodeID.isHidden = true
            }
        }
        else if (score2 >= 15){
            gameOver = true
            endLabel.text = "Player 2 Wins"
            endLabel.isHidden = false
            endLabel.position = CGPoint(x: 0, y: self.frame.height / 8)
            again.isHidden = false
            again.position = CGPoint(x: 0, y: -self.frame.height / 8)
            for i in inPlay{
                i.nodeID.isHidden = true
            }
        }
    }
    func multiTouchStart (touches: Set<UITouch>){
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
                self.score2 = 0
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
    func touchMoveMulti (touches: Set<UITouch>){
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
}
