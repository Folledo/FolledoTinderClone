//
//  UpdateViewController.swift
//  FolledoTinder
//
//  Created by Samuel Folledo on 6/26/18.
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

class UpdateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate { //4
    
    @IBOutlet weak var backgroundImageView: UIImageView! //4
    @IBOutlet weak var profileImageView: UIImageView! //4
    @IBOutlet weak var userGenderSwitch: UISwitch! //4
    @IBOutlet weak var interestedUserSwitch: UISwitch! //4
    
    var hasProfilePic = false
    
    
//viewDidLoad
    override func viewDidLoad() { //4
        super.viewDidLoad() //4
        
    //4 //31mins when we load, we want to take what information we have on the user and provide it into the VC
        if let isFemale = PFUser.current()?["isFemale"] as? Bool { //4 //32mins
            userGenderSwitch.setOn(isFemale, animated: false) //4 //32mins
        }  //4//32mins
        
        
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] as? Bool {  //4//32mins
            interestedUserSwitch.setOn(isInterestedInWomen, animated: false)  //4//32mins
//            backgroundImageView.image = UIImage(named: "redBG")  //4//set BG to red
        }  //4//32mins
//        else { //4
//            backgroundImageView.image = UIImage(named: "blueBG") //4
//        } //4
        
        if interestedUserSwitch.isOn {
            self.backgroundImageView.image = UIImage(named: "redBG")
        } else {
            self.backgroundImageView.image = UIImage(named: "blueBG")
        }
        
    //4 //33mins now get the photo to the imageView
        if let photo = PFUser.current()?["photo"] as? PFFile { //4
            photo.getDataInBackground { (data, error) in  //4//34mins
                if let imageData = data {  //4//34mins pull out the data
                    if let image = UIImage(data: imageData) { //4//35mins
                        self.profileImageView.image = image //4//35mins puts the image to the imageView
                    }
                }
            }
        }
        
        //createWomen() //5 to add the women users
        
    }

//4//14mins didFinishPickingMediaWithInfo method that will handle once the user selects an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { //4//14mins //pull the image from the info dictionary
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage { //4 //15mins this will only move forward if we're able to pull this out info and convertable to a UIImage
            profileImageView.image = image //4 //15mins
        }
        dismiss(animated: true, completion: nil) //4 //15mins DONT FORGET TO ALLOW PHOTO LIBRARY USAGE IN INFO.PLIST
    } //4
    
//updateImageTapped //4
    @IBAction func updateImageTapped(_ sender: Any) { //4
        let imagePicker = UIImagePickerController() //4 //12mins
        imagePicker.delegate = self //4 //12mins
        imagePicker.sourceType = .photoLibrary //4 //12mins
        imagePicker.allowsEditing = false //4 //12mins
        present(imagePicker, animated: true, completion: nil) //4 //13mins
    }
    
//saveTapped  //4
    @IBAction func saveTapped(_ sender: Any) { //4 //20mins
        
     //4//20mins access user
        PFUser.current()?["isFemale"] = userGenderSwitch.isOn //4 //21mins "isFemale" is a key which will be equal to the switch's on/off
        PFUser.current()?["isInterestedInWomen"] = interestedUserSwitch.isOn  //4//21mins
        
     //4//next is to save whatever image they used
        if let image = profileImageView.image { //4 //23mins
            if let imageData = UIImagePNGRepresentation(image) { //4 //23mins
                PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData) //4 //24mins now we have the photo,
                
                PFUser.current()?.saveInBackground(block: { (success, error) in //4
                    
                    if error != nil { //4 //24mins
                        var errorMessage = "Save failed, please try again." //4 //24mins default value for errorMessage
                        if let newError = error as NSError? { //4 //24mins
                            if let detailError = newError.userInfo["error"] as? String { //4 //24mins
                                errorMessage = detailError //4 //24mins
                            }
                            self.displayAlert(title: "Save Failed", message: errorMessage) //4 //display an alert
                            
                        }
                        
                    } else { //4
                        print("Update Successful") //4 //24mins
                        self.performSegue(withIdentifier: "updateToSwipeSegue", sender: nil) //6 //2mins
                        //self.displayAlert(title: "Success!", message: "Update has been successful") //4 //display an alert
                    }
                    
                }) //end of saveInBackground
            }
        }
    } //end of saveTapped
    
    
 //4//displayAlert method
    func displayAlert(title:String, message:String) { //4
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
//createWomen
    func createWomen() { //5 //3mins
        let imageUrls = ["https://www.shutterstock.com/image-photo/pretty-smiling-joyfully-female-fair-hair-776697943", "https://thumb9.shutterstock.com/display_pic_with_logo/2797510/348952868/stock-photo-portrait-of-beautiful-girl-on-white-background-wearing-white-bathrobe-348952868.jpg", "https://thumb1.shutterstock.com/display_pic_with_logo/2967241/662130583/stock-photo-portrait-of-young-pretty-cheerful-girl-smiling-looking-at-camera-over-white-background-662130583.jpg", "https://thumb1.shutterstock.com/display_pic_with_logo/2000294/666220159/stock-photo-headshot-of-young-adorable-blonde-woman-with-cute-smile-on-white-background-666220159.jpg", "https://thumb7.shutterstock.com/display_pic_with_logo/2000294/1018725367/stock-photo-adorable-happy-young-blonde-woman-in-pink-knitted-hat-scarf-having-fun-drinking-hot-tea-from-mug-1018725367.jpg"] //5
        
        var counter = 0 //5
        for imageUrl in imageUrls { //5 //5mins
            counter += 1
            if let url = URL(string: imageUrl) { //5 //to make sure these are working urls
            
                if let data = try? Data(contentsOf: url) { //5 //6mins only move forward if we can appropriately get the data
                    
                    let imageFile = PFFile(name: "photo.png", data: data) //5 //6mins name it photo.png and pass the data to it
                    
                    let user = PFUser() //5 //7mins create a user
                    user["photo"] = imageFile //5
                    user.username = String(counter) //5 //their username will be the current counter and returned as a string
                    user.password = "abc123" //5
                    user["isFemale"] = true //5
                    user["isInterestedInWomen"] = false //5
                    
                    user.signUpInBackground { (success, error) in //5 //9mins
                        if success { //5
                            print("Women User created!") //5
                        } else { //5
                            print("Women User NOT CREATED") //5
                        } //5
                    } //5
                } //5
            } //5
        } //5
    } //5 //end of createWomen
    
}
