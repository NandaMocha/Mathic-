//
//  GameScene.swift
//  Mazic!
//
//  Created by Nanda Mochammad on 15/05/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let manager = CMMotionManager()
    var player = SKSpriteNode()
    var goals = SKSpriteNode()
    
    var locX : CGFloat?
    var locY : CGFloat?
//    var playerX :
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        player = self.childNode(withName: "player") as! SKSpriteNode
        goals = self.childNode(withName: "Goals") as! SKSpriteNode
        
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.5
        manager.startAccelerometerUpdates(to: OperationQueue.main){
            (data, error) in
            self.locX = CGFloat((data?.acceleration.x)!) * 10
            self.locY = CGFloat((data?.acceleration.y)!) * 10
            self.physicsWorld.gravity = CGVector(dx: self.locX!, dy: self.locY!)
//            print("Player Location ", self.player.centerRect.maxX, self.player.centerRect.maxY)

        }
        
        self.addOverlay()

        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2 || bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 1{
            print("Goals")
            
        }
    }
    
    func addOverlay() {
        let randA = CGFloat.random(in: 0 ... 350)
        let randB = CGFloat.random(in: 0 ... 800)
        let overlay = createOverlay(frame: view!.frame,
                                    xOffset: randA,
                                    yOffset: randB,
                                    radius: 50.0)
        view!.addSubview(overlay)
    }
    
    func createOverlay(frame: CGRect,
                       xOffset: CGFloat,
                       yOffset: CGFloat,
                       radius: CGFloat) -> UIView {
        print(xOffset, yOffset)
        print(frame)
        // Step 1
        let overlayView = UIView(frame: frame)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        // Step 2
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: xOffset, y: yOffset),
                    radius: radius,
                    startAngle: 0.0,
                    endAngle: 2.0 * .pi,
                    clockwise: false)
        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))
        // Step 3
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.withAlphaComponent(0.2).cgColor
        maskLayer.path = path
        // For Swift 4.2
        maskLayer.fillRule = .evenOdd
        // Step 4
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        
        return overlayView
    }
    
    override func update(_ currentTime: TimeInterval) {

    }
}
