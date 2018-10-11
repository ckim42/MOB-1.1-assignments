//
//  Orange.swift
//  Orange Tree
//
//  Created by Cherish Kim on 10/10/18.
//  Copyright © 2018 Cherish Kim. All rights reserved.
//

import SpriteKit

class Orange: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "Orange")
        let size = texture.size()
        let color = UIColor.clear
        super.init(texture: texture, color: color, size: size)
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        //makes a circular physics body that fits the orange outline
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")
    }
}
