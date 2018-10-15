//
//  Character.swift
//  SushiNeko
//
//  Created by Cherish Kim on 10/14/18.
//  Copyright © 2018 Cherish Kim. All rights reserved.
//

import Foundation
import SpriteKit

class Character: SKSpriteNode{
    
    let punch = SKAction.animate(with: [SKTexture(imageNamed: "character2.png"), SKTexture(imageNamed: "character3.png")], timePerFrame: 0.07, resize: false, restore: true)
    var side: Side = .left{
        didSet{
            if side == .left {
                xScale = 1
                position.x = 70
            } else {
                xScale = -1
                position.x = 252
            }
            run(punch)
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
