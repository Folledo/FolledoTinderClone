//
//  MatchTableViewCell.swift
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

class MatchTableViewCell: UITableViewCell {  //7 //25mins created this cell
    
    var recipientObjectId = ""
    
    @IBOutlet weak var messageTextField: UITextField! //7 //27mins
    @IBOutlet weak var messageLabel: UILabel! //7 //27mins
    @IBOutlet weak var profileImageView: UIImageView! //7 //27mins
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
//sendTapped method for the send button
    @IBAction func sendTapped(_ sender: Any) { //7 //27mins
        //7 //42mins a message consists who the message is from, and who the message is being sent to, and what goes inside that message. This will be a class of its own
        let message = PFObject(className: "Message") //7 //43mins create a new table
        message["sender"] = PFUser.current()?.objectId //7 //43mins
        message["recipient"] = recipientObjectId //7 //46mins take whatever's in recipientObjectId and we're gonna set it as our "recipient"
        message["content"] = messageTextField.text //7 //43mins content is the text in messageTextField
        
        message.saveInBackground() //7 //43mins
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
