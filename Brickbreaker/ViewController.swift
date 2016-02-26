//
//  ViewController.swift
//  Brickbreaker
//
//  Created by Noah Guy on 2/26/16.
//  Copyright © 2016 Noah Guy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    

    var paddle = UIView()
    var ball = UIView()
    var brick = UIView()
    var objectsArray : [UIView] = []
    var bricksArray: [UIView] = []
    var myDynamicAnimator = UIDynamicAnimator()
    var collisionBehavior = UICollisionBehavior()
    var pushBehavior = UIPushBehavior()
    override func viewDidLoad() {
        super.viewDidLoad()
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
        view.addSubview(ball)
        
        let ballDynamicBehavior = UIDynamicItemBehavior(items: [ball])
        ballDynamicBehavior.friction = 0.0
        ballDynamicBehavior.resistance = 0.0
        ballDynamicBehavior.elasticity = 1.0
        ballDynamicBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(ballDynamicBehavior)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func drag(sender: AnyObject) {
        
    }

}

