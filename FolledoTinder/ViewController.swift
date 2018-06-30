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
//7 Location and Matches    =
/*                          = gives the ability to make sure that you're only doing matches with people who are in your location
                            = see who you've matched with (both users said yes to each other)
                            = chance to start messaging with them so that you can talk and chat with them
 */

import UIKit
import Parse //1

class ViewController: UIViewController {
    
    var displayUserID = ""  //6 //28mins whatever woman that shows up, we should take whatever her objectID is and we should pass it into this property
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var matchImageView: UIImageView! //7 //13mins //change all swipeLabel to this imageView
    //logoutTapped
    @IBAction func logoutTapped(_ sender: Any) { //6 //5mins
        PFUser.logOut() //6 //5mins
        performSegue(withIdentifier: "logoutSegue", sender: nil) //6 //5mins
    } //6 //5mins
    
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:))) //2 //5mins
        matchImageView.addGestureRecognizer(gesture) //2 //6mins //this add the gesture on swipeLabel. Make sure to check "User Interaction Enabled" in the storyboard
        
        if let username = PFUser.current()?.username {
            self.navItem.title = "Hi \(username)"
        }
        
        updateImage() //6 //28mins
        
        
    //7 //1mins after allowing location usage in info.plist, this is how you grab the current user's location
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error) in //7 //2mins
            if let point = geoPoint { //7 //2mins
                PFUser.current()?["location"] = point //7 //2mins
                PFUser.current()?.saveInBackground() //7 //3mins just simply save it //now that we have current user's location, we now have to update our query
            }
        }
    }
    
    
    //wasDragged 2
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) { //2 //5mins
        //print("dragged")
        //7mins where is the user is trying to move outlets to
        let labelPoint = gestureRecognizer.translation(in: view) //2 //7mins translation returns a point identifying the new location of a view in the coordinate system of its designated superview
        matchImageView.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y) //2 //8mins How we update where this label should be. //The x means the width of the screen divided by 2 because it is in the middle + whatever the value is of labelPoint.x
        //print("x:\(swipeLabel.center.x) , y:\(swipeLabel.center.y)")
        
        let xFromCenter = view.bounds.width / 2 - matchImageView.center.x //2 //22mins middle of screen - middle of label
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200) //2 //18mins An affine transformation matrix is used to rotate, scale, translate, or skew the objects you draw in a graphics context
        
        let scale = min(100 / abs(xFromCenter), 1) //2 //24mins //cool effect as it approaches the edge, but the middle would turn too big //25mins //'min' gives perfect effect going to the left, but going to the right it would still get bigger //27mins put 'abs' to keep xFromCenter always positive
        var scaledAndRotated = rotation.scaledBy(x: scale, y: scale) //2 //19mins would shrink it a little bit
        matchImageView.transform = scaledAndRotated //2 //20mins //dont forget to revert back to their original position, size, rotation in .ended state
        
        if gestureRecognizer.state == .ended { //2 //12mins if gesture recognizer ended //this is now where we decide if they move far enough to the left or right
            
            var acceptedOrRejected = "" //6 //28mins create a new variable if the swipe has ended
            
            if matchImageView.center.x < (view.bounds.width / 2 - 150) { //2 //12mins
                print("not interested") //2 //12mins
                acceptedOrRejected = "rejected" //6 //28mins var to put on the rejected array attributes of the user
                
            } //2 //12mins
            if matchImageView.center.x > (view.bounds.width / 2 + 150) { //2 //12mins
                print("interested") //2 //12mins
                acceptedOrRejected = "accepted" //6 //28mins
            } //2 //12mins
            
            if acceptedOrRejected != "" && displayUserID != "" { //6 //31mins check if they have values first
                
                PFUser.current()?.addUniqueObject(displayUserID, forKey: acceptedOrRejected) //6 //31mins this is how you can add it to an array //'addUniqueObject' Adds an object to the array associated with a given key, only if it is not already present in the array. The position of the insert is not guaranteed. //so here we are taking our displayUserID and add it to either our accepted or rejected array attributes
                
                PFUser.current()?.saveInBackground(block: { (success, error) in //6 //32mins now that we have added another's userID, we want to save and update the Parse Server
                    if success { //6 //32mins if saving happened successfully, run our updateImage to view the next user
                        self.updateImage() //6 32mins we should now be able to see other users' objectID in our array of either accepted or rejected
                    }
                })
            }
            
            
            rotation = CGAffineTransform(rotationAngle: 0) //2 //28mins go back to its original rotation
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1) //2 //28mins and their original size
            matchImageView.transform = scaledAndRotated //2 //29mins apply the transformation to swipeLabel
            
            matchImageView.center = CGPoint(x: view.bounds.width / 2 , y: view.bounds.height / 2) //2 //15mins puts the label back to the center of the screen
        } //2 end of .ended state
        
    } //2 end of wasDragged method
    
    
    func updateImage() { //7 //16mins
        if let query = PFUser.query() { //24mins PFQuery was changed to PFUser.query
            
            if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] { //18mins
                
                query.whereKey("isFemale", equalTo: isInterestedInWomen) //17mins //we're checking is this user's isFemale the same thing as what our current logged in user's isInterestedInWomen //*the query has to be equal/matching/same to the value of both isFemale and isInterestInWomen*. For a guy user interested in women, both values has to be true, meaning, user's isInterestInWomen is true and other user's isFemale is true) //19mins
            }
            
            if let isFemale = PFUser.current()?["isFemale"] { //19mins to see the gender

                query.whereKey("isInterestedInWomen", equalTo: isFemale) //19mins //if the other user is also looking for the same gender the current user is looking for
            }
            
            //6 //34mins what we want to do with this query us figure out which users our current user has already interacted with. And if any users the current user already said yes or no to, then we dont include them into this query
            var ignoredUsers: [String] = []
            
            if let acceptedUsers = PFUser.current()?["accepted"] as? [String] { //6 //36mins check and see if anybody is in the current user's accepted column
                ignoredUsers += acceptedUsers //6 //36mins if they are in our current user's accepted column already, then we add them to our ignoredUsers array, so our query can ignore those users
            } //6 //36mins
            if let rejectedUsers = PFUser.current()?["rejected"] as? [String] { //6 //37mins also add the people that we have rejected to our ignoredUsers array
                ignoredUsers += rejectedUsers //6 //37mins when we query, if the current users has already said yes or no to those users, then we dont want them to show up again
            } //6 //37mins
            
            query.whereKey("objectId", notContainedIn: ignoredUsers) //6 //34mins check any users who have objectId that's inside the ignoreUsers, if they're in there then we dont want them to be a part of this query
            
            
            //7 //5mins first get the geopoint from the logged in user
            if let geoPoint = PFUser.current()?["location"] as? PFGeoPoint { //7 //6mins if we get a geoPoint with lat and longitude then we proceed
                
                query.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: geoPoint.latitude - 1, longitude: geoPoint.longitude - 1), toNortheast: PFGeoPoint(latitude: geoPoint.latitude + 1, longitude: geoPoint.longitude + 1)) //7 //7mins built a box around the current user to only see other users inside that box
                
            }
            
            
            query.limit = 1 //6 //19mins limits the query to one at a time
            
            query.findObjectsInBackground { (objects, error) in
                if let users = objects  { //6 //20mins
                    for object in users { //6 //20mins make sure theres only one user
                        if let user = object as? PFUser { //6 //21mins check if user is a PFUser
                            if let imageFile = user["photo"] as? PFFile { //6 //21mins now that we have a user, what we need is the user's photo
                                
                                 //6//22mins once we get the imageFile, we take this imageFile and download that photo
                                imageFile.getDataInBackground(block: { (data, error) in //6
                                    if let imageData = data { //6 //make sure we can unwrap this data
                                        self.matchImageView.image = UIImage(data: imageData) //6 //22mins set the matchImageView with the newly created image from imageData
                                        
                                        
                                        if let objectID = object.objectId { //6 //29mins
                                            self.displayUserID = objectID //6 //29mins pass the object's objectID to the displayUserID
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
        
        
} //end of the ViewController.swift

