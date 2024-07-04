//
//  StartGameScene.swift
//  HorizonChase
//
//  Created by Denis Haritonenko on 4.07.24.
//

import SpriteKit
import GameplayKit

class StartGameScene: SKScene {
    // MARK: - Nodes
    private var startButton: SKShapeNode!
    
    // MARK: - Overrides
    override func didMove(to view: SKView) {
        
        setupBackground()
        addLogo()
        
        let scoreLabelPosition = CGPoint(x: frame.midX, y: frame.midY + 120)
        let score = UserDefaults.standard.integer(forKey: "HighScore")
        addLabel(score.description, fontSize: 100, at: scoreLabelPosition)
        
        let bestScoreLabelPosition = CGPoint(x: frame.midX, y: frame.midY)
        addLabel("Best Score", fontSize: 40, at: bestScoreLabelPosition)
        
        setupStartButton()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if startButton.contains(location) {
            print("Button pressed")
            
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                view?.presentScene(scene)
            }
        }
    }
    
    // MARK: - Setup Nodes
    private func setupStartButton() {
        let buttonSize = CGSize(width: 500, height: 100)
        let cornerRadius = buttonSize.height / 2
        
        startButton = SKShapeNode(rectOf: buttonSize, cornerRadius: cornerRadius)
        startButton.fillColor = .white
        startButton.strokeColor = .clear
        startButton.position = CGPoint(x: frame.midX, y: frame.midY - 300)
        addChild(startButton)
        
        let label = SKLabelNode(fontNamed: "SFProText-Heavy")
        label.text = "START GAME"
        label.fontSize = 40
        label.fontColor = .black
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: 0)
        startButton.addChild(label)
    }
    
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "hcBackground")
        background.zPosition = -1
        let scaleX = self.size.width / background.texture!.size().width
        let scaleY = self.size.height / background.texture!.size().height
        let scale = max(scaleX, scaleY)
        background.xScale = scale
        background.yScale = scale
        addChild(background)
    }
    
    private func addLogo() {
        let sprite = SKSpriteNode(imageNamed: "hcLogo")
        sprite.position = CGPoint(x: frame.midX, y: frame.maxY - 200)
        addChild(sprite)
    }
    
    private func addLabel(_ text: String, fontSize: CGFloat, at position: CGPoint) {
        
        let label = SKLabelNode(text: text)
        label.fontName = "SFProText-Heavy"
        label.fontSize = fontSize
        label.fontColor = .white
        
        let padding: CGFloat = 20
        let backgroundSize = CGSize(width: label.frame.width + padding * 2, height: label.frame.height + padding * 2)
        
        let background = SKShapeNode(rectOf: backgroundSize)
        background.fillColor = SKColor(named: "labelBackground") ?? .red
        
        label.position = CGPoint(x: 0, y: -label.frame.height / 2)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        
        let container = SKNode()
        container.addChild(background)
        container.addChild(label)
        container.position = position
        
        addChild(container)
    }
}
