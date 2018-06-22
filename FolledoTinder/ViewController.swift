//
//  ViewController.swift
//  FolledoTinder
//
//  Created by Samuel Folledo on 6/22/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

//1 Setting Up Parse Server
//2 Dragging Objects
//3 Login & Signup
//4 Adding User Details
//5 Adding Users
//6 Swiping Users
//7 Location and Matches

import UIKit
import Parse //1

class ViewController: UIViewController {
    
    @IBOutlet weak var swipeLabel: UILabel! //2
    
//viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:))) //2 //5mins
        swipeLabel.addGestureRecognizer(gesture) //2 //6mins //this add the gesture on swipeLabel. Make sure to check "User Interaction Enabled" in the storyboard
    }
    
    
//wasDragged 2
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) { //2 //5mins
        //print("dragged")
        //7 minswhere is the user is trying to move outlets to
        let labelPoint = gestureRecognizer.translation(in: view) //2 //7mins translation returns a point identifying the new location of a view in the coordinate system of its designated superview
        swipeLabel.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y) //2 //8mins How we update where this label should be. //The x means the width of the screen divided by 2 because it is in the middle + whatever the value is of labelPoint.x
        //print("x:\(swipeLabel.center.x) , y:\(swipeLabel.center.y)")
        
        let xFromCenter = view.bounds.width / 2 - swipeLabel.center.x //2 //22mins middle of screen - middle of label
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200) //2 //18mins An affine transformation matrix is used to rotate, scale, translate, or skew the objects you draw in a graphics context
        
        let scale = min(100 / abs(xFromCenter), 1) //2 //24mins //cool effect as it approaches the edge, but the middle would turn too big //25mins //'min' gives perfect effect going to the left, but going to the right it would still get bigger //27mins put 'abs' to keep xFromCenter always positive
        var scaledAndRotated = rotation.scaledBy(x: scale, y: scale) //2 //19mins would shrink it a little bit
        swipeLabel.transform = scaledAndRotated //2 //20mins //dont forget to revert back to their original position, size, rotation in .ended state
        
        if gestureRecognizer.state == .ended { //2 //12mins if gesture recognizer ended //this is now where we decide if they move far enough to the left or right
            if swipeLabel.center.x < (view.bounds.width / 2 - 150) { //2
                print("not interested")
            }
            if swipeLabel.center.x > (view.bounds.width / 2 + 150) { //2
                print("interested")
            }
            
            rotation = CGAffineTransform(rotationAngle: 0) //2 //28mins go back to its original rotation
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1) //2 //28mins and their original size
            swipeLabel.transform = scaledAndRotated //2 //29mins apply the transformation to swipeLabel
            
            swipeLabel.center = CGPoint(x: view.bounds.width / 2 , y: view.bounds.height / 2) //2 //15mins puts the label back to the center of the screen
        } //2 end of .ended state
        
    } //2 end of wasDragged method

//didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


} //end of the ViewController.swift

