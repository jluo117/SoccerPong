//
//  ball.swift
//  SoccerPong
//
//  Created by james luo on 2/14/18.
//  Copyright © 2018 james luo. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
class ball{
    var nodeID : SKNode
    var isPowerUp : Bool
    init(nodeID: SKNode, isPowerUp: Bool) {
        self.nodeID = nodeID
        self.isPowerUp = isPowerUp
    }
}
