//
//  GameScene.swift
//  HorizonChase
//
//  Created by Denis Haritonenko on 2.07.24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private lazy var visibleFrame: CGRect = {
        if let view = self.view {
            let topLeft = CGPoint(x: view.bounds.minX, y: view.bounds.maxY)
            let topLeftInScene = self.convertPoint(fromView: topLeft)
            
            let topRight = CGPoint(x: view.bounds.maxX, y: view.bounds.maxY)
            let topRightInScene = self.convertPoint(fromView: topRight)
            
            let bottomLeft = CGPoint(x: view.bounds.minX, y: view.bounds.minY)
            let bottomLeftInScene = self.convertPoint(fromView: bottomLeft)
            
            let visibleWidth = topRightInScene.x - topLeftInScene.x
            let visibleHeight =  bottomLeftInScene.y - topLeftInScene.y
            
            return CGRect(x: topLeftInScene.x, y: topLeftInScene.y, width: visibleWidth, height: visibleHeight)
        }
        return frame
    }()
    
    // MARK: - Properties
    private var score = 0 {
        didSet {
            scoreLabel.text = score.description
        }
    }
    
    private let laneSpeed: CGFloat = 4
    private let shoulderWidth: CGFloat = 40
    private let laneLineHeight: CGFloat = 200
    private let laneLineWidth: CGFloat = 22
    private let laneLineGapHeight: CGFloat = 120
    private let laneLineDifference: CGFloat = 120
    private var laneLineAndGapHeight: CGFloat {
        laneLineHeight + laneLineGapHeight
    }
    private var laneWidth: CGFloat {
        (visibleFrame.width - shoulderWidth * 2) / 3
    }
    private var startLanePositionY: CGFloat = -200
    
    private var currentLane = 2
    private var numberOfLanes = 3
    private func getRandomLaneX() -> CGFloat {
        let lane = Int.random(in: -1...1)
        return visibleFrame.midX + CGFloat(lane) * laneWidth
    }
    
    // MARK: - Nodes
    private var racingCar: SKSpriteNode!
    private var rightArrow: SKSpriteNode!
    private var leftArrow: SKSpriteNode!
    private var scoreLabel: SKLabelNode!
    
    private var policeCars: [SKSpriteNode] = []
    
    // MARK: - Overrides
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(named: "asphaltColor") ?? UIColor.gray
        
        racingCar = SKSpriteNode(imageNamed: "racingCar")
        let scaleX = 100 / racingCar.texture!.size().width
        let scaleY = 100 / racingCar.texture!.size().height
        let scale = max(scaleX, scaleY)
        racingCar.xScale = scale
        racingCar.yScale = scale
        racingCar.position = CGPoint(x: visibleFrame.midX, y: visibleFrame.minX + 100)
        
        racingCar.physicsBody = SKPhysicsBody(rectangleOf: racingCar.size)
        racingCar.physicsBody?.categoryBitMask = 0x1
        racingCar.physicsBody?.affectedByGravity = false
        racingCar.physicsBody?.isDynamic = false
        
        addChild(racingCar)
        
        spawnPoliceCar()
        
        rightArrow = SKSpriteNode(imageNamed: "rightChevron")
        rightArrow.position = CGPoint(x: visibleFrame.maxX - 110, y: visibleFrame.minY + 120)
        rightArrow.setScale(0.6)
        rightArrow.name = "rightArrow"
        addChild(rightArrow)
        
        leftArrow = SKSpriteNode(imageNamed: "leftChevron")
        leftArrow.position = CGPoint(x: visibleFrame.minX + 110, y: visibleFrame.minY + 120)
        leftArrow.setScale(0.6)
        leftArrow.name = "leftArrow"
        addChild(leftArrow)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(drawLaneLines), userInfo: nil, repeats: true)
        
        // TODO: Random interval
        Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(spawnPoliceCar), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(goToStartGameScene), userInfo: nil, repeats: false)
        
        physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(fontNamed: "SFProText-Heavy")
        scoreLabel.fontSize = 60
        scoreLabel.zPosition = 200
        scoreLabel.fontColor = SKColor(named: "labelBackground") ?? .red
        scoreLabel.position = CGPoint(x: visibleFrame.minX + 110, y: visibleFrame.maxY - 120)
        scoreLabel.text = score.description
        addChild(scoreLabel)
    }
    
    /// Check for overtake
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        for policeCar in policeCars {
            if racingCar.position.y > policeCar.position.y + policeCar.size.height / 2 {
                print("overtake")
                score += 1
                if let index = policeCars.firstIndex(of: policeCar) {
                    policeCars.remove(at: index)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if rightArrow.contains(location) {
                moveCarRight()
            } else if leftArrow.contains(location) {
                moveCarLeft()
            }
        }
    }
    
    // MARK: - Methods
    @objc func spawnPoliceCar() {
        let policeCar = SKSpriteNode(imageNamed: "policeCar")
        let laneX = getRandomLaneX()
        policeCar.position = CGPoint(x: laneX, y: visibleFrame.maxY + 100)
        
        let scaleX = 100 / policeCar.texture!.size().width
        let scaleY = 100 / policeCar.texture!.size().height
        let scale = max(scaleX, scaleY)
        policeCar.xScale = scale
        policeCar.yScale = scale
        
        policeCar.physicsBody = SKPhysicsBody(rectangleOf: policeCar.size)
        policeCar.physicsBody?.categoryBitMask = 0x10
        
        addChild(policeCar)
        policeCars.append(policeCar)
        
        let moveAction = SKAction.move(to: CGPoint(x: laneX, y: visibleFrame.minY - 100), duration: 5.0)
        policeCar.run(moveAction) {
            print("remove")
            policeCar.removeFromParent()
            if let index = self.policeCars.firstIndex(of: policeCar) {
                self.policeCars.remove(at: index)
            }
        }
        
        policeCar.physicsBody?.contactTestBitMask = racingCar.physicsBody?.categoryBitMask ?? 0
    }
    
    @objc func drawLaneLines() {
        startLanePositionY -= laneSpeed
        if startLanePositionY <= visibleFrame.minY - laneLineAndGapHeight {
            startLanePositionY = visibleFrame.minY
        }
        
        for node in self.children {
            if node.name == "laneLine" {
                node.removeFromParent()
            }
        }
        
        for index in stride(from: startLanePositionY, to: visibleFrame.maxY + laneLineAndGapHeight, by: laneLineAndGapHeight){
            drawLaneLine(at: CGPoint(x: visibleFrame.minX + shoulderWidth, y: index))
            drawLaneLine(at: CGPoint(x: visibleFrame.minX + shoulderWidth + laneWidth * 2, y: index))
        }
        
        for index in stride(from: startLanePositionY + laneLineDifference, to: visibleFrame.maxY  + laneLineAndGapHeight, by: laneLineAndGapHeight) {
            drawLaneLine(at: CGPoint(x: visibleFrame.minX + shoulderWidth + laneWidth, y: index))
            drawLaneLine(at: CGPoint(x: visibleFrame.minX + shoulderWidth + laneWidth * 3, y: index))
        }
    }
    
    private func drawLaneLine(at position: CGPoint) {
        let laneLine = SKShapeNode(rectOf: CGSize(width: laneLineWidth, height: laneLineHeight))
        laneLine.fillColor = .white
        laneLine.position = position
        laneLine.name = "laneLine"
        addChild(laneLine)
    }
    
    private func moveCarRight() {
        if currentLane + 1 <= numberOfLanes {
            currentLane += 1
            let newPositionX = visibleFrame.minX + shoulderWidth +  laneWidth * CGFloat(currentLane - 1) + laneWidth / 2
            let moveAction = SKAction.moveTo(x: newPositionX, duration: 0.2)
            racingCar.run(moveAction)
        }
    }
    
    private func moveCarLeft() {
        if currentLane - 1 >= 1 {
            currentLane -= 1
            let newPositionX = visibleFrame.minX + shoulderWidth +  laneWidth * CGFloat(currentLane - 1) + laneWidth / 2
            let moveAction = SKAction.moveTo(x: newPositionX, duration: 0.2)
            racingCar.run(moveAction)
        }
    }
    
    func goToGameOverScene() {
        saveScoreIfNeeded()
        let transition = SKTransition.fade(withDuration: 0.5)
        if let scene = SKScene(fileNamed: "GameOverScene") {
            scene.scaleMode = .aspectFill
            view?.presentScene(scene, transition: transition)
        }
    }
    
    @objc func goToStartGameScene() {
        saveScoreIfNeeded()
        let transition = SKTransition.fade(withDuration: 0.5)
        if let scene = SKScene(fileNamed: "StartGameScene") {
            scene.scaleMode = .aspectFill
            view?.presentScene(scene, transition: transition)
        }
    }
    
    func saveScoreIfNeeded() {
        let bestScore = UserDefaults.standard.integer(forKey: "HighScore")
        if score > bestScore {
            UserDefaults.standard.set(score, forKey: "HighScore")
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & 0x1 != 0) && (secondBody.categoryBitMask & 0x10 != 0) {
            goToGameOverScene()
        }
    }
}
