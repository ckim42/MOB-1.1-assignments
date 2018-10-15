//
//  GameScene.swift
//  SushiNeko
//
//  Created by Cherish Kim on 10/14/18.
//  Copyright © 2018 Cherish Kim. All rights reserved.
//

import SpriteKit

enum GameState{
    
    case title
    case ready
    case playing
    case gameOver
}


class GameScene: SKScene {
    var levelCounter: Int = 0
    var sushiTower: [SushiPiece] = []
    var sushiBasePiece: SushiPiece!
    var feline: Character!
    var state: GameState = .title
    var playButton: MSButtonNode!
    var healthBar: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var health: CGFloat = 1.0 {
        didSet {
            /* Cap Health */
            if health > 1.0 { health = 1.0 }
            
            /* Scale health bar between 0.0 -> 1.0 e.g 0 -> 100% */
            healthBar.xScale = health
        }
    }
    var score: Int = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    

    var character: Character!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        sushiBasePiece = childNode(withName: "sushiBasePiece") as? SushiPiece
        sushiBasePiece.connectChopsticks()
        sushiBasePiece = childNode(withName: "sushiBasePiece") as? SushiPiece
        
        character = childNode(withName: "character") as? Character
        feline = childNode(withName: "feline") as? Character
//        healthBar = childNode(withName: "healthBar") as! SKSpriteNode
        
        sushiBasePiece.connectChopsticks()
        
        addTowerPiece(side: .none)
        addRandomSushiPieces(total: 5)
        
//        playButton = childNode(withName: "playButton") as! MSButtonNode
        playButton.selectedHandler = {
            self.state = .ready
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if feline.side == sushiTower.first?.side as? Side {
            
            gameOver()
            
            /* No need to continue as player is dead */
            return
        }
        
        if state == .gameOver || state == .title { return }
        if state == .ready { state = .playing}
        
        let touch = touches.first!
        let location = touch.location(in: self)
        if location.x > size.width / 2 {
            feline.side = .right
        }else{
            feline.side = .left
        }
        
        if let firstPiece = sushiTower.first as SushiPiece? {
            
            sushiTower.removeFirst()
            firstPiece.flip(side: feline.side)
            addRandomSushiPieces(total: 1)
        }
        
        /* Increment health */
        health += 0.1
        
        /* Increment Score */
        score += 1
    
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveTowerDown()
        
        /* Called before each frame is rendered */
        if state != .playing { return }
        
        /* Decrease Health */
        health -= 0.01
        /* Has the player ran out of health? */
        if health < 0 {
            gameOver()
        }
    }
    
    
    /// Method to add a piece of sushi in the tower
    func addTowerPiece(side: Side) {
        
        // Getting the positions of the last piece
        let newPiece = sushiBasePiece.copy() as! SushiPiece
        let lastPiece = sushiTower.last
        let lastPosition = lastPiece?.position ?? sushiBasePiece.position
        let lastZPosition = lastPiece?.zPosition ?? sushiBasePiece.zPosition
        
        // Setting up the new piece positions based on the last piece
        newPiece.connectChopsticks()
        newPiece.position.x = lastPosition.x
        newPiece.position.y = lastPosition.y + 55
        newPiece.zPosition = lastZPosition + 1
        newPiece.side = side
        
        // Adding new sushi to the scene and array
        addChild(newPiece)
        sushiTower.append(newPiece)
    }
    
    func gameOver() {
        /* Game over! */
        
        state = .gameOver
        
        /* Create turnRed SKAction */
        let turnRed = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.50)
        
        /* Turn all the sushi pieces red*/
        sushiBasePiece.run(turnRed)
        for sushiPiece in sushiTower {
            sushiPiece.run(turnRed)
        }
        
        /* Make the player turn red */
        feline.run(turnRed)
        
        /* Change play button selection handler */
        playButton.selectedHandler = {
            
            /* Grab reference to the SpriteKit view */
            let skView = self.view as SKView?
            
            /* Load Game scene */
            guard let scene = GameScene(fileNamed: "GameScene") as GameScene? else {
                return
            }
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .aspectFill
            
            /* Restart GameScene */
            skView?.presentScene(scene)
        }
    }
    
    /// Method to add a set number of pieces randomly on the tower
    func addRandomSushiPieces(total: Int){
        
        for _ in 1...total{
            let lastPiece = sushiTower.last!
            if lastPiece.side != .none {
                addTowerPiece(side: .none)
            } else {
                let randomNumber = arc4random_uniform(100)
                if randomNumber < 45 {
                    addTowerPiece(side: .left)
                } else if randomNumber < 90 {
                    addTowerPiece(side: .right)
                } else {
                    addTowerPiece(side: .none)
                }
            }
        }
    }
    
    /// Method to move down the tower each time a piece is removed
    func moveTowerDown(){
        var n: CGFloat = 0
        
        sushiTower.forEach { (piece) in
            let y = (n * 55) + 215
            piece.position.y -= (piece.position.y - y) * 0.5
            n += 1
        }
    }
    
}
