//
//  GameOverScene.swift
//  HorizonChase
//
//  Created by Denis Haritonenko on 4.07.24.
//

import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        let sprite = SKSpriteNode(imageNamed: "gameOver")
        sprite.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(sprite)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.transitionToNextScene()
        }
    }
    
    func transitionToNextScene() {
        let transition = SKTransition.fade(withDuration: 0.5)
        if let scene = SKScene(fileNamed: "StartGameScene") {
            scene.scaleMode = .aspectFill
            view?.presentScene(scene, transition: transition)
        }
    }
}

