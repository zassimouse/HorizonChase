//
//  GameScene.swift
//  HorizonChase
//
//  Created by Denis Haritonenko on 2.07.24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(named: "asphaltColor") ?? UIColor.gray
        
        let racingCar = SKSpriteNode(imageNamed: "racingCar")
        racingCar.setScale(0.2)
        racingCar.position = CGPoint(x: frame.midX, y: frame.minX + 100)

        addChild(racingCar)
    }
}
