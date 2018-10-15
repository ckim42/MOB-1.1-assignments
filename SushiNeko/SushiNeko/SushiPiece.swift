//
//  SushiPiece.swift
//  SushiNeko
//
//  Created by Cherish Kim on 10/14/18.
//  Copyright © 2018 Cherish Kim. All rights reserved.
//

import SpriteKit

class SushiPiece: SKSpriteNode{
    
    var rightChopstick: SKSpriteNode!
    var leftChopstick: SKSpriteNode!
    
    var side: Side = .none{
        
        didSet{
            
            switch side {
                
            case .left:
                
                leftChopstick.isHidden = false
                
            case .right:
                
                rightChopstick.isHidden = false
                
            case .none:
                leftChopstick.isHidden = true
                rightChopstick.isHidden = true
            }
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    ///Method to connect the chopsticks to the sushi
    func connectChopsticks() {
        rightChopstick = childNode(withName: "rightChopstick") as? SKSpriteNode
        leftChopstick = childNode(withName: "leftChopstick") as? SKSpriteNode
        side = .none
    }
    
    func flip(side: Side){
        var actionName: String = ""
        if side == .left {
            actionName = "FlipRight"
        } else if side == .right {
            actionName = "FlipRight"
        }
        
        let flip = SKAction(named: actionName)!
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([flip,remove])
        
        run(sequence)
        
    }
}
