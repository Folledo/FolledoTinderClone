//
//  MatchesViewController.swift
//  FolledoTinder
//
//  Created by Samuel Folledo on 7/1/18.
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
import Parse

class MatchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {  //7 //21mins added data source and delegate, must have numberOfRowsInSection and cellForRowAt
    
    @IBOutlet weak var tableView: UITableView! //7 //20mins
    
    var images: [UIImage] = [] //7 //36mins
    var userIds: [String] = [] //7 //36mins
    var messages: [String] = [] //7 //52mins
    
//backTapped
    @IBAction func backTapped(_ sender: Any) { //7 //13mins
        dismiss(animated: true, completion: nil) //7 //13mins
    }
    
//viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self //7 //21mins
        tableView.delegate = self  //7 //21mins
        
        if let query = PFUser.query() { //7 //29mins
            query.whereKey("accepted", contains: PFUser.current()?.objectId) //7 //29mins make sure that the users in here are inside the current logged in user's accepted array
            if let acceptedUsers = PFUser.current()?["accepted"] as? [String] {
                query.whereKey("objectId", containedIn: acceptedUsers)//7 //30mins make sure it's true the other way around, that the other user also has the current logged in user in their accepted array //pretty much these 2 whereKeys make sure that both users said yes to each other, now we can launch our query
                
                query.findObjectsInBackground { (objects, error) in //7 //33mins
                    if let unwrappedUsers = objects { //7 //33mins
                        for user in unwrappedUsers { //7 //33mins
                            if let theUser = user as? PFUser { //7 //33mins here we're trying to make sure that this user we got is an actual PFUser //now we have an individual user, which we can now grab their photo
                                if let imageFile = theUser["photo"] as? PFFile {  //7 //34mins
                                    imageFile.getDataInBackground(block: { (data, error) in
                                        if let imageData = data { //7 //35mins now we have our images //now we create 2 arrays, 1 to hold the images, and the other that holds the userId, so that we know who they are and we can send messages to them
                                            if let image = UIImage(data: imageData){
                                                //self.images.append(image) //7 //36mins adds the image data to images array //55mins append things at the same time
                                                if let objectId = theUser.objectId { //7 //37mins
                                                    //self.userIds.append(objectId) //7 //37mins //55mins append everything at the same time
                                                    
                                                 //7 //47mins before we update our table, we'll do one more query where we check the messages and see if there's any for us from people that we have matched with.
                                                    let messagesQuery = PFQuery(className: "Message") //7 //48mins
                                                    if let currentUser = PFUser.current()?.objectId { //7 //48mins
                                                        messagesQuery.whereKey("recipient", equalTo: currentUser) //7 //49mins
                                                    }
                                                    messagesQuery.whereKey("sender", equalTo: theUser.objectId!) //7 //50mins
                                                    
                                                    messagesQuery.findObjectsInBackground(block: { (objects, error) in //7 //50mins now let's see if we can find some messages
                                                        var messageText = "No message from this user" //7 //51mins default value if there's no messages
                                                        if let objects = objects { //7 //51mins if there is a message... then unwrap it
                                                            for message in objects { //7 //51mins then for loop through all the messages
                                                                if let content = message["content"] as? String { //7 //52mins now we see the content of the message
                                                                    messageText = content //7 //52mins create an array that will hold all of the messages //put the content to the messageText
                                                                }
                                                            }
                                                        }
                                                        self.messages.append(messageText) //7 //53mins //append the content to the messages array, if no message then the default value of messageText will be displayed instead //don't forget to update the cell's messageLabel.text
                                                        self.userIds.append(objectId) //7 //37mins
                                                        self.images.append(image) //7 //36mins adds the image data to images array
                                                        self.tableView.reloadData() //7 //37mins update the tableView
                                                    })
                                                    //self.tableView.reloadData() //7 //37mins update the tableView //reload data after doing the last query and appends
                                                }
                                            }//7 //38mins now we have the userId and their images to our array where we can now update our image in our cell
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }


//numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  //7 //22mins
        return images.count //7 //38mins
    } //7 //22mins
    
//cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //7 //22mins
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as? MatchTableViewCell { //7 //22mins
            
            cell.messageLabel.text = "You haven't received a message yet" //7 //28mins //since we created the cell as a MatchTableViewCell, we can now access its messageLabel created in that swift file
            cell.profileImageView.image = images[indexPath.row] //7 //38mins equal it to images and get whats ever at indexPath.row
            
            cell.recipientObjectId = userIds[indexPath.row] //7 //45mins a way of transfering some information over to the cell to say hey this is who are going to be the objectId if you're going to be sending the message
            cell.messageLabel.text = messages[indexPath.row] //54mins
            
            return cell //7 //22mins
        }
        
        return UITableViewCell()
    } //7 //22mins
    
    
}
