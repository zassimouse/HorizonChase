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
    
    private let laneSpeed = CGFloat(4)
    private var startLanePositionY = CGFloat(-200)
    private let shoulderWidth = CGFloat(40) // обочина
    private let laneLineHeight = CGFloat(100)
    private let laneLineGapHeight = CGFloat(60)
    private let laneLineDifference = CGFloat(60)
    
    private var laneLineAndGapHeight: CGFloat {
        laneLineHeight + laneLineGapHeight
    }
    private var laneWidth: CGFloat {
        (visibleFrame.width - shoulderWidth * 2) / 3
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(named: "asphaltColor") ?? UIColor.gray
        
        let racingCar = SKSpriteNode(imageNamed: "racingCar")
        racingCar.setScale(0.2)
        racingCar.position = CGPoint(x: frame.midX, y: frame.minX + 100)
        addChild(racingCar)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(drawLaneLines), userInfo: nil, repeats: true)
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
        let laneLine = SKShapeNode(rectOf: CGSize(width: 15, height: 100))
        laneLine.fillColor = .white
        laneLine.position = position
        laneLine.name = "laneLine"
        addChild(laneLine)
    }
}
