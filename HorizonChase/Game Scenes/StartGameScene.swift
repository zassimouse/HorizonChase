//
//  StartGameScene.swift
//  HorizonChase
//
//  Created by Denis Haritonenko on 4.07.24.
//

import SpriteKit
import GameplayKit

class StartGameScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black

        let startLabel = SKLabelNode(text: "Start Game")
        startLabel.fontSize = 50
        startLabel.fontColor = SKColor.white
        startLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(startLabel)

        let tapToStartLabel = SKLabelNode(text: "Tap to Start")
        tapToStartLabel.fontSize = 30
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        addChild(tapToStartLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let view = view {
            let transition = SKTransition.flipHorizontal(withDuration: 0.5)
            let scene = GameScene(size: size)
            view.presentScene(scene, transition: transition)
        }
    }
}
