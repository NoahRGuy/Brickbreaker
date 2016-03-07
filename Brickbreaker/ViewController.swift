//
//  ViewController.swift
//  Brickbreaker
//
//  Created by Noah Guy on 2/26/16.
//  Copyright © 2016 Noah Guy. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    var paddle = UIView()
    var ball = UIView()
    var brick = UIView()
    var objectsArray : [UIView] = []
    var bricksArray: [UIView] = []
    var myDynamicAnimator = UIDynamicAnimator()
    var collisionBehavior = UICollisionBehavior()
    var pushBehavior = UIPushBehavior()
    var numLives = 5
    var points = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        addRow(10, xSpace: 10, Yoffset: 50, color: UIColor.orangeColor())
        myDynamicAnimator = UIDynamicAnimator(referenceView: view)
        ball = UIView(frame: CGRectMake(view.center.x - 10, view.center.y, 20, 20))
        objectsArray.append(ball)
        ball.layer.cornerRadius = 10.25
        ball.clipsToBounds = true
        ball.backgroundColor = UIColor.grayColor()
        view.addSubview(ball)
        
        paddle = UIView(frame: CGRectMake(view.center.x - 40, view.center.y * 1.7, 60, 30))
        objectsArray.append(paddle)
        paddle.layer.cornerRadius = 5
        paddle.clipsToBounds = true
        paddle.backgroundColor = UIColor.yellowColor()
        view.addSubview(paddle)
        
        let ballDynamicBehavior = UIDynamicItemBehavior(items: [ball])
        ballDynamicBehavior.friction = 0.0
        ballDynamicBehavior.resistance = 0.0
        ballDynamicBehavior.elasticity = 1.0
        ballDynamicBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(ballDynamicBehavior)
        
        let paddleDynamicBehavior = UIDynamicItemBehavior(items: [paddle])
        paddleDynamicBehavior.density = 100000
        paddleDynamicBehavior.resistance = 100
        paddleDynamicBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(paddleDynamicBehavior)
        
        let brickDynamicBehavior = UIDynamicItemBehavior(items: bricksArray)
        brickDynamicBehavior.density = 100000
        brickDynamicBehavior.resistance = 100
        brickDynamicBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(brickDynamicBehavior)
        
        pushBehavior = UIPushBehavior(items: [ball], mode: .Instantaneous)
        pushBehavior.angle = 1.1
        pushBehavior.magnitude = 0.2
        
        collisionBehavior = UICollisionBehavior(items: objectsArray)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .Everything
        collisionBehavior.collisionDelegate = self
        myDynamicAnimator.addBehavior(collisionBehavior)
    }

    @IBAction func start(sender: UIButton) {
        startButton.hidden = true
        myDynamicAnimator.addBehavior(pushBehavior)
    }

    @IBAction func drag(sender: AnyObject) {
        let dragGesture = sender.locationInView(view).x
        paddle.center.x = dragGesture
        myDynamicAnimator.updateItemUsingCurrentState(paddle)
    }

    func addRow(numBricks: Int, xSpace: Int, Yoffset: Int, color : UIColor){
        var blockX = 10
        var blockY = Yoffset
        let width = (Int(view.frame.width - 20)) / numBricks - 1 * xSpace
        
        for each in 1...numBricks{
           let newBrick = UIView(frame: CGRectMake(CGFloat(blockX), CGFloat(blockY), CGFloat(width), 20))
            newBrick.backgroundColor = color
            view.addSubview(newBrick)
            bricksArray.append(newBrick)
            objectsArray.append(newBrick)
            collisionBehavior.addItem(newBrick)
            myDynamicAnimator.updateItemUsingCurrentState(newBrick)
            blockX += (width + xSpace)
        }
        resetBrickBehavior()
    }
    //Color order: Red -> Orange -> Yellow
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        for brick in bricksArray {
        if(item1.isEqual(ball) && item2.isEqual(brick) || item1.isEqual(brick) && item2.isEqual(ball)){
        points += 10
        scoreLabel.text = "Score: \(points)"
            if(brick.backgroundColor == UIColor.redColor()){
                brick.backgroundColor = UIColor.orangeColor()
            }
            else if(brick.backgroundColor == UIColor.orangeColor()){
                brick.backgroundColor = UIColor.yellowColor()
            }
            else if(brick.backgroundColor == UIColor.yellowColor()){
                brick.hidden = true
                collisionBehavior.removeItem(brick)
                bricksArray.removeAtIndex(bricksArray.indexOf(brick)!)
                objectsArray.removeAtIndex(objectsArray.indexOf(brick)!)
                myDynamicAnimator.updateItemUsingCurrentState(brick)
            }
        }
        }
        if(bricksArray.isEmpty){
           resetBricks()
        }
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        if item.isEqual(ball) && p.y > paddle.center.y{
            if(numLives == 0){
            self.ball.removeFromSuperview()
            self.myDynamicAnimator.removeBehavior(pushBehavior)
            let endAlert = UIAlertController(title: "Game Over!", message: "What would you like to do?", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (cancelAction) -> Void in
                self.reset()
            })
            let resetAction = UIAlertAction(title: "Play Again!", style: .Default, handler: { (resetAction) -> Void in
              self.numLives = 5
              self.points = 0
              self.livesLabel.text = "Lives: \(self.numLives)"
              self.scoreLabel.text = "Score: \(self.points)"
                for each in self.bricksArray{
                    each.removeFromSuperview()
                    self.objectsArray.removeAtIndex(self.objectsArray.indexOf(each)!)
                    self.myDynamicAnimator.updateItemUsingCurrentState(each)
                }
                self.bricksArray.removeAll()
              self.ball.center = self.view.center
              self.view.addSubview(self.ball)
              self.paddle.center.x = self.view.center.x
              self.addRow(10, xSpace: 10, Yoffset: 50, color: UIColor.orangeColor())
              self.myDynamicAnimator.updateItemUsingCurrentState(self.ball)
              self.myDynamicAnimator.updateItemUsingCurrentState(self.paddle)
              self.resetBrickBehavior()
            })
            endAlert.addAction(cancelAction)
            endAlert.addAction(resetAction)
            presentViewController(endAlert, animated: true, completion: nil)
            }
            else{
            numLives -= 1
            livesLabel.text = "Lives: \(numLives)"
            self.ball.center = view.center
            myDynamicAnimator.updateItemUsingCurrentState(ball)
            }
        }
    }
    func reset(){
        startButton.hidden = false
        ball = UIView(frame: CGRectMake(view.center.x - 10, view.center.y, 20, 20))
    }
    func resetBricks(){
        ball.center = view.center
        myDynamicAnimator.updateItemUsingCurrentState(ball)
        var numRows = Int(arc4random_uniform(5) + 1)
        var originOffset = 50
        var color = UIColor.redColor()
        for each in 0...numRows{
            var ranColor = Int(arc4random_uniform(3))
            if(ranColor == 0){
                color = UIColor.redColor()
            }
            else if(ranColor == 1){
                color = UIColor.orangeColor()
            }
            else if(ranColor == 2){
                color = UIColor.yellowColor()
            }
            var numBlocks = Int(arc4random_uniform(15) + 1)
            addRow(Int(numBlocks), xSpace: 10, Yoffset: originOffset, color: color)
            originOffset += 25
            
        }
        
    }
    func resetBrickBehavior(){
        let brickDynamicBehavior = UIDynamicItemBehavior(items: bricksArray)
        brickDynamicBehavior.density = 100000
        brickDynamicBehavior.resistance = 100
        brickDynamicBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(brickDynamicBehavior)
    }
}

