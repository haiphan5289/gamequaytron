//
//  GameScene.swift
//  gamevongtron
//
//  Created by HaiPhan on 5/23/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import SpriteKit
import GameplayKit

enum playcolor {
    static let colors = [UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
                         UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
                        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
                        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]}
enum Switchcase: Int {
    case red, yellow, green, blue
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var circlecolor: SKSpriteNode!
    var ball: SKSpriteNode!
    enum physiccatelogi: UInt32{
        case circle = 1
        case ball = 2
        case none = 3
    }
    var switchcas = Switchcase.red
    var colorindex: Int?
    var timer: Timer!
    var labeltext = SKLabelNode(text: "0")
    var score: Int = 0
    override func didMove(to view: SKView) {
//        createcircle()
        setupphysic()
        roundSquareImage(imageName: "circle.png")
        createball()
        createlbael()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createball), userInfo: nil, repeats: true)

        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    func createlbael(){
        labeltext.position = CGPoint(x: self.view!.frame.width/2, y: self.view!.frame.height/2)
        labeltext.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        labeltext.fontSize = 20
        self.addChild(labeltext)
    }
    func setupphysic(){
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        physicsWorld.contactDelegate = self
    }
    @objc func createball(){
        colorindex = Int(arc4random_uniform(UInt32(4)))
        ball = SKSpriteNode(texture: SKTexture(image: UIImage(named: "ball.png")!), color: playcolor.colors[colorindex!], size: CGSize(width: self.frame.size.width/7, height: self.frame.size.width/7))
//        ball = SKSpriteNode(imageNamed: "ball.png")
        ball.colorBlendFactor = 1
        ball.name = "Ball"
        ball.position = CGPoint(x: 200, y: self.view!.frame.height)
//        ball.size = CGSize(width: self.frame.size.width/7, height: self.frame.size.width/7)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
//        ball.physicsBody?.isDynamic = true
//        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = physiccatelogi.ball.rawValue
        ball.physicsBody?.contactTestBitMask = physiccatelogi.circle.rawValue
        ball.physicsBody?.collisionBitMask = physiccatelogi.none.rawValue
        self.addChild(ball)
    }
    func createcircle(){
        circlecolor = SKSpriteNode(imageNamed: "circle.png")
        circlecolor.position = CGPoint(x: 200, y: 200)
        circlecolor.size = CGSize(width: self.frame.width/3, height: self.frame.width/3)
//        roundSquareImage(imageName: "circle.png")
        self.addChild(circlecolor)
    
//        let tile = SKShapeNode(rect: CGRect(x: 50, y: 50, width: 30, height: 30), cornerRadius: 15)
//        self.addChild(tile)
    }
    //radius image rồi ép image vào spritenode
    func roundSquareImage(imageName: String) -> SKSpriteNode {
        let originalPicture = UIImage(named: imageName)
        // create the image with rounded corners
        UIGraphicsBeginImageContextWithOptions(originalPicture!.size, false, 0)
        let rect = CGRect(x: 0, y: 0, width: originalPicture!.size.width, height: originalPicture!.size.width)
        let rectPath : UIBezierPath = UIBezierPath(roundedRect: rect, cornerRadius: self.frame.width/2)
        rectPath.addClip()
        originalPicture!.draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        
        let texture = SKTexture(image: scaledImage)
        circlecolor = SKSpriteNode(texture: texture, size: CGSize(width: originalPicture!.size.width, height: originalPicture!.size.height))
        circlecolor.name = imageName
        circlecolor.position = CGPoint(x: 220, y: circlecolor.size.width/4)
        circlecolor.size = CGSize(width: self.frame.width/3, height: self.frame.width/3)
        circlecolor.physicsBody = SKPhysicsBody(circleOfRadius: circlecolor.size.width/2)
        circlecolor.physicsBody?.isDynamic = false
//        circlecolor.physicsBody?.affectedByGravity = false
        circlecolor.physicsBody?.categoryBitMask = physiccatelogi.circle.rawValue
//        circlecolor.physicsBody?.contactTestBitMask = physiccatelogi.ball.rawValue
        circlecolor.run(SKAction.rotate(byAngle: .pi/2, duration: 0.1))
        circlecolor.run(SKAction.rotate(byAngle: .pi/2, duration: 0.1))
        circlecolor.run(SKAction.rotate(byAngle: .pi/2, duration: 0.1))
        circlecolor.run(SKAction.rotate(byAngle: 150, duration: 0.1))
        self.addChild(circlecolor)
        return circlecolor
    }
    func turnwheel(){
        if let newstate = Switchcase(rawValue: switchcas.rawValue + 1) {
            switchcas = newstate
        }
        else {
            switchcas = .red
        }
        circlecolor.run(SKAction.rotate(byAngle: .pi/2, duration: 0.5))
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == physiccatelogi.circle.rawValue || contact.bodyB.categoryBitMask == physiccatelogi.circle.rawValue {
            if contact.bodyA.categoryBitMask == physiccatelogi.ball.rawValue || contact.bodyB.categoryBitMask == physiccatelogi.ball.rawValue {
                if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                    if colorindex == switchcas.rawValue {
                        score += 1
                        labeltext.text = String(score)
                        ball.removeFromParent()
                    }
                }}}
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self))
        }
        turnwheel()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self))
//            circlecolor.position = t.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

}

